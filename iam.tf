locals {
  create_role = var.create && var.create_function && !var.create_layer && var.create_role

  # Lambda@Edge uses the Cloudwatch region closest to the location where the function is executed
  # The region part of the LogGroup ARN is then replaced with a wildcard (*) so Lambda@Edge is able to log in every region
  log_group_arn_regional = element(concat(data.aws_cloudwatch_log_group.lambda.*.arn, aws_cloudwatch_log_group.lambda.*.arn, [""]), 0)
  log_group_name         = element(concat(data.aws_cloudwatch_log_group.lambda.*.name, aws_cloudwatch_log_group.lambda.*.name, [""]), 0)
  log_group_arn          = local.create_role && var.lambda_at_edge ? format("arn:%s:%s:%s:%s:%s", data.aws_arn.log_group_arn[0].partition, data.aws_arn.log_group_arn[0].service, "*", data.aws_arn.log_group_arn[0].account, data.aws_arn.log_group_arn[0].resource) : local.log_group_arn_regional

  # Defaulting to "*" (an invalid character for an IAM Role name) will cause an error when
  #   attempting to plan if the role_name and function_name are not set.  This is a workaround
  #   for #83 that will allow one to import resources without receiving an error from coalesce.
  # @see https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/83
  role_name = local.create_role ? coalesce(var.role_name, var.function_name, "*") : null

  # IAM Role trusted entities is a list of any (allow strings (services) and maps (type+identifiers))
  trusted_entities_services = distinct(compact(concat(
    slice(["lambda.amazonaws.com", "edgelambda.amazonaws.com"], 0, var.lambda_at_edge ? 2 : 1),
    [for service in var.trusted_entities : try(tostring(service), "")]
  )))

  trusted_entities_principals = [
    for principal in var.trusted_entities : {
      type        = principal.type
      identifiers = tolist(principal.identifiers)
    }
    if !can(tostring(principal))
  ]
}

###########
# IAM role
###########

data "aws_iam_policy_document" "assume_role" {
  count = local.create_role ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = local.trusted_entities_services
    }

    dynamic "principals" {
      for_each = local.trusted_entities_principals
      content {
        type        = principals.value.type
        identifiers = principals.value.identifiers
      }
    }
  }
}

resource "aws_iam_role" "lambda" {
  count = local.create_role ? 1 : 0

  name                  = local.role_name
  description           = var.role_description
  path                  = var.role_path
  force_detach_policies = var.role_force_detach_policies
  permissions_boundary  = var.role_permissions_boundary
  assume_role_policy    = data.aws_iam_policy_document.assume_role[0].json

  tags = merge(var.tags, var.role_tags)
}

##################
# Cloudwatch Logs
##################

data "aws_arn" "log_group_arn" {
  count = local.create_role && var.lambda_at_edge ? 1 : 0

  arn = local.log_group_arn_regional
}

data "aws_iam_policy_document" "logs" {
  count = local.create_role && var.attach_cloudwatch_logs_policy ? 1 : 0

  statement {
    effect = "Allow"

    actions = compact([
      !var.use_existing_cloudwatch_log_group ? "logs:CreateLogGroup" : "",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ])

    resources = flatten([for _, v in ["%v:*", "%v:*:*"] : format(v, local.log_group_arn)])
  }
}

resource "aws_iam_policy" "logs" {
  count = local.create_role && var.attach_cloudwatch_logs_policy ? 1 : 0

  name   = "${local.role_name}-logs"
  policy = data.aws_iam_policy_document.logs[0].json
  tags   = var.tags
}

resource "aws_iam_policy_attachment" "logs" {
  count = local.create_role && var.attach_cloudwatch_logs_policy ? 1 : 0

  name       = "${local.role_name}-logs"
  roles      = [aws_iam_role.lambda[0].name]
  policy_arn = aws_iam_policy.logs[0].arn
}

#####################
# Dead Letter Config
#####################

data "aws_iam_policy_document" "dead_letter" {
  count = local.create_role && var.attach_dead_letter_policy ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "sns:Publish",
      "sqs:SendMessage",
    ]

    resources = [
      var.dead_letter_target_arn,
    ]
  }
}

resource "aws_iam_policy" "dead_letter" {
  count = local.create_role && var.attach_dead_letter_policy ? 1 : 0

  name   = "${local.role_name}-dl"
  policy = data.aws_iam_policy_document.dead_letter[0].json
  tags   = var.tags
}

resource "aws_iam_policy_attachment" "dead_letter" {
  count = local.create_role && var.attach_dead_letter_policy ? 1 : 0

  name       = "${local.role_name}-dl"
  roles      = [aws_iam_role.lambda[0].name]
  policy_arn = aws_iam_policy.dead_letter[0].arn
}

######
# VPC
######

# Copying AWS managed policy to be able to attach the same policy with multiple roles without overwrites by another function
data "aws_iam_policy" "vpc" {
  count = local.create_role && var.attach_network_policy ? 1 : 0

  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaENIManagementAccess"
}

resource "aws_iam_policy" "vpc" {
  count = local.create_role && var.attach_network_policy ? 1 : 0

  name   = "${local.role_name}-vpc"
  policy = data.aws_iam_policy.vpc[0].policy
  tags   = var.tags
}

resource "aws_iam_policy_attachment" "vpc" {
  count = local.create_role && var.attach_network_policy ? 1 : 0

  name       = "${local.role_name}-vpc"
  roles      = [aws_iam_role.lambda[0].name]
  policy_arn = aws_iam_policy.vpc[0].arn
}

#####################
# Tracing with X-Ray
#####################

# Copying AWS managed policy to be able to attach the same policy with multiple roles without overwrites by another function
data "aws_iam_policy" "tracing" {
  count = local.create_role && var.attach_tracing_policy ? 1 : 0

  arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

resource "aws_iam_policy" "tracing" {
  count = local.create_role && var.attach_tracing_policy ? 1 : 0

  name   = "${local.role_name}-tracing"
  policy = data.aws_iam_policy.tracing[0].policy
  tags   = var.tags
}

resource "aws_iam_policy_attachment" "tracing" {
  count = local.create_role && var.attach_tracing_policy ? 1 : 0

  name       = "${local.role_name}-tracing"
  roles      = [aws_iam_role.lambda[0].name]
  policy_arn = aws_iam_policy.tracing[0].arn
}

###############################
# Failure/Success Async Events
###############################

data "aws_iam_policy_document" "async" {
  count = local.create_role && var.attach_async_event_policy ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "sns:Publish",
      "sqs:SendMessage",
      "events:PutEvents",
      "lambda:InvokeFunction",
    ]

    resources = compact(distinct([var.destination_on_failure, var.destination_on_success]))
  }
}

resource "aws_iam_policy" "async" {
  count = local.create_role && var.attach_async_event_policy ? 1 : 0

  name   = "${local.role_name}-async"
  policy = data.aws_iam_policy_document.async[0].json
  tags   = var.tags
}

resource "aws_iam_policy_attachment" "async" {
  count = local.create_role && var.attach_async_event_policy ? 1 : 0

  name       = "${local.role_name}-async"
  roles      = [aws_iam_role.lambda[0].name]
  policy_arn = aws_iam_policy.async[0].arn
}

###########################
# Additional policy (JSON)
###########################

resource "aws_iam_policy" "additional_json" {
  count = local.create_role && var.attach_policy_json ? 1 : 0

  name   = local.role_name
  policy = var.policy_json
  tags   = var.tags
}

resource "aws_iam_policy_attachment" "additional_json" {
  count = local.create_role && var.attach_policy_json ? 1 : 0

  name       = local.role_name
  roles      = [aws_iam_role.lambda[0].name]
  policy_arn = aws_iam_policy.additional_json[0].arn
}

#####################################
# Additional policies (list of JSON)
#####################################

resource "aws_iam_policy" "additional_jsons" {
  count = local.create_role && var.attach_policy_jsons ? var.number_of_policy_jsons : 0

  name   = "${local.role_name}-${count.index}"
  policy = var.policy_jsons[count.index]
  tags   = var.tags
}

resource "aws_iam_policy_attachment" "additional_jsons" {
  count = local.create_role && var.attach_policy_jsons ? var.number_of_policy_jsons : 0

  name       = "${local.role_name}-${count.index}"
  roles      = [aws_iam_role.lambda[0].name]
  policy_arn = aws_iam_policy.additional_jsons[count.index].arn
}

###########################
# ARN of additional policy
###########################

resource "aws_iam_role_policy_attachment" "additional_one" {
  count = local.create_role && var.attach_policy ? 1 : 0

  role       = aws_iam_role.lambda[0].name
  policy_arn = var.policy
}

######################################
# List of ARNs of additional policies
######################################

resource "aws_iam_role_policy_attachment" "additional_many" {
  count = local.create_role && var.attach_policies ? var.number_of_policies : 0

  role       = aws_iam_role.lambda[0].name
  policy_arn = var.policies[count.index]
}

###############################
# Additional policy statements
###############################

data "aws_iam_policy_document" "additional_inline" {
  count = local.create_role && var.attach_policy_statements ? 1 : 0

  dynamic "statement" {
    for_each = var.policy_statements

    content {
      sid           = lookup(statement.value, "sid", replace(statement.key, "/[^0-9A-Za-z]*/", ""))
      effect        = lookup(statement.value, "effect", null)
      actions       = lookup(statement.value, "actions", null)
      not_actions   = lookup(statement.value, "not_actions", null)
      resources     = lookup(statement.value, "resources", null)
      not_resources = lookup(statement.value, "not_resources", null)

      dynamic "principals" {
        for_each = lookup(statement.value, "principals", [])
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = lookup(statement.value, "not_principals", [])
        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = lookup(statement.value, "condition", [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_policy" "additional_inline" {
  count = local.create_role && var.attach_policy_statements ? 1 : 0

  name   = "${local.role_name}-inline"
  policy = data.aws_iam_policy_document.additional_inline[0].json
  tags   = var.tags
}

resource "aws_iam_policy_attachment" "additional_inline" {
  count = local.create_role && var.attach_policy_statements ? 1 : 0

  name       = local.role_name
  roles      = [aws_iam_role.lambda[0].name]
  policy_arn = aws_iam_policy.additional_inline[0].arn
}
