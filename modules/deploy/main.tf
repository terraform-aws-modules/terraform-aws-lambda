locals {
  # AWS CodeDeploy can't deploy when CurrentVersion is "$LATEST"
  current_version = data.aws_lambda_function.this[0].qualifier == "$LATEST" ? 1 : data.aws_lambda_function.this[0].qualifier

  app_name              = element(concat(aws_codedeploy_app.this.*.name, [var.app_name]), 0)
  deployment_group_name = element(concat(aws_codedeploy_deployment_group.this.*.deployment_group_name, [var.deployment_group_name]), 0)

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
    ]) : map(k, v)]
  } : {})

  appspec_content = replace(jsonencode(local.appspec), "\"", "\\\"")
  appspec_sha256  = sha256(jsonencode(local.appspec))

  script = <<EOF
ID=$(aws deploy create-deployment \
    --application-name ${local.app_name} \
    --deployment-group-name ${local.deployment_group_name} \
    --deployment-config-name ${var.deployment_config_name} \
    --description "My demo deployment" \
    --revision '{"revisionType": "AppSpecContent", "appSpecContent": {"content": "${local.appspec_content}", "sha256": "${local.appspec_sha256}"}}' \
    --output text \
    --query '[deploymentId]')

STATUS=$(aws deploy get-deployment \
    --deployment-id $ID \
    --output text \
    --query '[deploymentInfo.status]')

while [[ $STATUS == "Created" || $STATUS == "InProgress" || $STATUS == "Pending" || $STATUS == "Queued" || $STATUS == "Ready" ]]; do
    echo "Status: $STATUS..."
    STATUS=$(aws deploy get-deployment \
        --deployment-id $ID \
        --output text \
        --query '[deploymentInfo.status]')
    sleep 5
done

if [[ $STATUS == "Succeeded" ]]; then
    EXITCODE=0
    echo "Deployment finished."
else
    EXITCODE=1
    echo "Deployment failed!"
fi

aws deploy get-deployment --deployment-id $ID
exit $EXITCODE
EOF

}

data "aws_lambda_alias" "this" {
  count = var.create ? 1 : 0

  function_name = var.function_name
  name          = var.alias_name
}

data "aws_lambda_function" "this" {
  count = var.create ? 1 : 0

  function_name = var.function_name
  qualifier     = data.aws_lambda_alias.this[0].function_version
}

resource "local_file" "deploy_script" {
  count = var.create && var.save_deploy_script ? 1 : 0

  filename             = "deploy_script_${local.appspec_sha256}.txt"
  directory_permission = "0755"
  file_permission      = "0755"
  content              = local.script
}

resource "null_resource" "deploy" {
  count = var.create && var.create_deployment ? 1 : 0

  triggers = {
    appspec_sha256 = local.appspec_sha256
  }

  provisioner "local-exec" {
    command = local.script
  }
}

resource "aws_codedeploy_app" "this" {
  count = var.create_app && ! var.use_existing_app ? 1 : 0

  name             = var.app_name
  compute_platform = "Lambda"
}

//resource "aws_codedeploy_deployment_config" "this" {
//  deployment_config_name = "test-deployment-config"
//  compute_platform       = "Lambda"
//
//  traffic_routing_config {
//    type = "TimeBasedLinear"
//
//    time_based_linear {
//      interval   = 10
//      percentage = 10
//    }
//  }
//}

resource "aws_codedeploy_deployment_group" "this" {
  count = var.create_deployment_group && ! var.use_existing_deployment_group ? 1 : 0

  app_name               = local.app_name
  deployment_group_name  = var.deployment_group_name
  service_role_arn       = aws_iam_role.codedeploy.arn
  deployment_config_name = var.deployment_config_name

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_STOP_ON_ALARM"]
  }

  alarm_configuration {
    alarms  = ["my-alarm-name"]
    enabled = true
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
}

resource "aws_iam_role_policy_attachment" "codedeploy" {
  role       = aws_iam_role.codedeploy.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRoleForLambda"
}

resource "aws_iam_role" "codedeploy" {
  name               = "${var.app_name}-codedeploy"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codedeploy.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}
//
//output "this_codedeploy_app_name" {
//  value = aws_codedeploy_app.this.name
//}
//
//output "this_codedeploy_deployment_config_id" {
//  value = aws_codedeploy_deployment_config.this.id
//}
//
//output "this_codedeploy_deployment_config_deployment_config_id" {
//  value = aws_codedeploy_deployment_config.this.deployment_config_id
//}
