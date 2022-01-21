locals {
  # AWS CodeDeploy can't deploy when CurrentVersion is "$LATEST"
  qualifier       = try(data.aws_lambda_function.this[0].qualifier, "")
  current_version = local.qualifier == "$LATEST" ? 1 : local.qualifier

  app_name              = try(aws_codedeploy_app.this[0].name, var.app_name)
  deployment_group_name = try(aws_codedeploy_deployment_group.this[0].deployment_group_name, var.deployment_group_name)

  appspec = merge({
    version = "0.0"
    Resources = [
      {
        MyFunction = {
          Type = "AWS::Lambda::Function"
          Properties = {
            Name           = var.function_name
            Alias          = var.alias_name
            CurrentVersion = var.current_version != "" ? var.current_version : local.current_version
            TargetVersion : var.target_version
          }
        }
      }
    ]
    }, var.before_allow_traffic_hook_arn != "" || var.after_allow_traffic_hook_arn != "" ? {
    Hooks = [for k, v in zipmap(["BeforeAllowTraffic", "AfterAllowTraffic"], [
      var.before_allow_traffic_hook_arn != "" ? var.before_allow_traffic_hook_arn : null,
      var.after_allow_traffic_hook_arn != "" ? var.after_allow_traffic_hook_arn : null
    ]) : tomap({ (k) = v }) if v != null]
  } : {})

  appspec_content = replace(jsonencode(local.appspec), "\"", "\\\"")
  appspec_sha256  = sha256(jsonencode(local.appspec))

  script = <<EOF
#!/bin/bash

if [[ '${var.target_version}' == '${var.current_version != "" ? var.current_version : local.current_version}' ]]; then
  echo "Skipping deployment because target version (${var.target_version}) is already the current version"
  exit 0
fi

ID=$(${var.aws_cli_command} deploy create-deployment \
    --application-name ${local.app_name} \
    --deployment-group-name ${local.deployment_group_name} \
    --deployment-config-name ${var.deployment_config_name} \
    --description "${var.description}" \
    --revision '{"revisionType": "AppSpecContent", "appSpecContent": {"content": "${local.appspec_content}", "sha256": "${local.appspec_sha256}"}}' \
    --output text \
    --query '[deploymentId]')

%{if var.wait_deployment_completion}
STATUS=$(${var.aws_cli_command} deploy get-deployment \
    --deployment-id $ID \
    --output text \
    --query '[deploymentInfo.status]')

while [[ $STATUS == "Created" || $STATUS == "InProgress" || $STATUS == "Pending" || $STATUS == "Queued" || $STATUS == "Ready" ]]; do
    echo "Status: $STATUS..."
    STATUS=$(${var.aws_cli_command} deploy get-deployment \
        --deployment-id $ID \
        --output text \
        --query '[deploymentInfo.status]')

    SLEEP_TIME=$((( $RANDOM % 5 ) + ${var.get_deployment_sleep_timer}))

    echo "Sleeping for: $SLEEP_TIME Seconds"
    sleep $SLEEP_TIME
done

${var.aws_cli_command} deploy get-deployment --deployment-id $ID

if [[ $STATUS == "Succeeded" ]]; then
    echo "Deployment succeeded."
else
    echo "Deployment failed!"
    exit 1
fi

%{else}

${var.aws_cli_command} deploy get-deployment --deployment-id $ID
echo "Deployment started, but wait deployment completion is disabled!"

%{endif}
EOF

}

data "aws_lambda_alias" "this" {
  count = var.create && var.create_deployment ? 1 : 0

  function_name = var.function_name
  name          = var.alias_name
}

data "aws_lambda_function" "this" {
  count = var.create && var.create_deployment ? 1 : 0

  function_name = var.function_name
  qualifier     = data.aws_lambda_alias.this[0].function_version
}

resource "local_file" "deploy_script" {
  count = var.create && var.create_deployment && var.save_deploy_script ? 1 : 0

  filename             = "deploy_script_${local.appspec_sha256}.txt"
  directory_permission = "0755"
  file_permission      = "0644"
  content              = local.script
}

resource "null_resource" "deploy" {
  count = var.create && var.create_deployment && var.run_deployment ? 1 : 0

  triggers = {
    appspec_sha256 = local.appspec_sha256
    force_deploy   = var.force_deploy ? uuid() : false
  }

  provisioner "local-exec" {
    command     = local.script
    interpreter = var.interpreter
  }

  depends_on = [
    aws_iam_role_policy_attachment.hooks
  ]
}

resource "aws_codedeploy_app" "this" {
  count = var.create && var.create_app && !var.use_existing_app ? 1 : 0

  name             = var.app_name
  compute_platform = "Lambda"
  tags             = var.tags
}

resource "aws_codedeploy_deployment_group" "this" {
  count = var.create && var.create_deployment_group && !var.use_existing_deployment_group ? 1 : 0

  app_name               = local.app_name
  deployment_group_name  = var.deployment_group_name
  service_role_arn       = try(aws_iam_role.codedeploy[0].arn, data.aws_iam_role.codedeploy[0].arn, "")
  deployment_config_name = var.deployment_config_name

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  auto_rollback_configuration {
    enabled = var.auto_rollback_enabled
    events  = var.auto_rollback_events
  }

  dynamic "alarm_configuration" {
    for_each = var.alarm_enabled ? [true] : []

    content {
      enabled                   = var.alarm_enabled
      alarms                    = var.alarms
      ignore_poll_alarm_failure = var.alarm_ignore_poll_alarm_failure
    }
  }

  dynamic "trigger_configuration" {
    for_each = var.triggers

    content {
      trigger_events     = trigger_configuration.value.events
      trigger_name       = trigger_configuration.value.name
      trigger_target_arn = trigger_configuration.value.target_arn
    }
  }

  tags = var.tags
}

data "aws_iam_role" "codedeploy" {
  count = var.create && !var.create_codedeploy_role ? 1 : 0

  name = var.codedeploy_role_name
}

resource "aws_iam_role" "codedeploy" {
  count = var.create && var.create_codedeploy_role ? 1 : 0

  name               = coalesce(var.codedeploy_role_name, "${local.app_name}-codedeploy")
  assume_role_policy = data.aws_iam_policy_document.assume_role[0].json
  tags               = var.tags
}


data "aws_iam_policy_document" "assume_role" {
  count = var.create && var.create_codedeploy_role ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = var.codedeploy_principals
    }
  }
}

resource "aws_iam_role_policy_attachment" "codedeploy" {
  count = var.create && var.create_codedeploy_role ? 1 : 0

  role       = try(aws_iam_role.codedeploy[0].id, "")
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRoleForLambda"
}

data "aws_iam_policy_document" "hooks" {
  count = var.create && var.create_codedeploy_role && var.attach_hooks_policy && (var.before_allow_traffic_hook_arn != "" || var.after_allow_traffic_hook_arn != "") ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "lambda:InvokeFunction",
    ]

    resources = compact([var.before_allow_traffic_hook_arn, var.after_allow_traffic_hook_arn])
  }

}

resource "aws_iam_policy" "hooks" {
  count = var.create && var.create_codedeploy_role && var.attach_hooks_policy && (var.before_allow_traffic_hook_arn != "" || var.after_allow_traffic_hook_arn != "") ? 1 : 0

  policy = data.aws_iam_policy_document.hooks[0].json
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "hooks" {
  count = var.create && var.create_codedeploy_role && var.attach_hooks_policy && (var.before_allow_traffic_hook_arn != "" || var.after_allow_traffic_hook_arn != "") ? 1 : 0

  role       = try(aws_iam_role.codedeploy[0].id, "")
  policy_arn = aws_iam_policy.hooks[0].arn
}

data "aws_iam_policy_document" "triggers" {
  count = var.create && var.create_codedeploy_role && var.attach_triggers_policy ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "sns:Publish",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "triggers" {
  count = var.create && var.create_codedeploy_role && var.attach_triggers_policy ? 1 : 0

  policy = data.aws_iam_policy_document.triggers[0].json
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "triggers" {
  count = var.create && var.create_codedeploy_role && var.attach_triggers_policy ? 1 : 0

  role       = try(aws_iam_role.codedeploy[0].id, "")
  policy_arn = aws_iam_policy.triggers[0].arn
}

# https://docs.aws.amazon.com/codedeploy/latest/userguide/deployment-configurations.html
# https://www.terraform.io/docs/providers/aws/r/codedeploy_deployment_config.html
#resource "aws_codedeploy_deployment_config" "this" {
#  deployment_config_name = "test-deployment-config"
#  compute_platform       = "Lambda"
#
#  traffic_routing_config {
#    type = "TimeBasedLinear"
#
#    time_based_linear {
#      interval   = 10
#      percentage = 10
#    }
#  }
#}
