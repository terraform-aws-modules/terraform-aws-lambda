provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

resource "random_pet" "this" {
  length = 2
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
  }
}

# Invocation is authorized by the Lambda resource policies below. This role has
# no identity policies that would independently allow direct invocation.
resource "aws_iam_role" "invoker" {
  name_prefix        = "${random_pet.this.id}-url-invoker-"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

locals {
  allowed_triggers = {
    InvokeFunctionUrl = {
      principal              = aws_iam_role.invoker.arn
      action                 = "lambda:InvokeFunctionUrl"
      function_url_auth_type = "AWS_IAM"
    }
    InvokeFunction = {
      principal                = aws_iam_role.invoker.arn
      action                   = "lambda:InvokeFunction"
      invoked_via_function_url = true
    }
  }
}

module "lambda_function" {
  source = "../../"

  function_name = "${random_pet.this.id}-function-url"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"
  publish       = true

  source_path = "${path.module}/../fixtures/python-function-url"

  create_lambda_function_url = true
  authorization_type         = "AWS_IAM"

  # This URL invokes the unqualified function, not a numbered version.
  create_current_version_allowed_triggers = false
  allowed_triggers                        = local.allowed_triggers

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "alias" {
  source = "../../modules/alias"

  name             = "live"
  function_name    = module.lambda_function.lambda_function_name
  function_version = module.lambda_function.lambda_function_version

  # Function URLs support named aliases, but not numbered versions.
  create_version_allowed_triggers = false
  allowed_triggers                = local.allowed_triggers
}

resource "aws_lambda_function_url" "alias" {
  function_name      = module.lambda_function.lambda_function_name
  qualifier          = module.alias.lambda_alias_name
  authorization_type = "AWS_IAM"
}
