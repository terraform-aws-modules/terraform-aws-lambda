provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

resource "random_pet" "this" {
  length = 2
}

module "lambda_function" {
  source = "../../"

  function_name = "${random_pet.this.id}-lambda"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  publish       = true

  source_path = "${path.module}/../fixtures/python3.8-app1"
  hash_extra  = "yo1"

  allowed_triggers = {
    APIGatewayAny = {
      service = "apigateway"
      arn     = "arn:aws:execute-api:eu-west-1:135367859851:aqnku8akd0"
    }
  }
}

module "alias_refresh" {
  source = "../../modules/alias"

  refresh_alias = true

  name = "current-with-refresh"

  function_name = module.lambda_function.this_lambda_function_name

  # Set function_version when creating alias to be able to deploy using it,
  # because AWS CodeDeploy doesn't understand $LATEST as CurrentVersion.
  function_version = module.lambda_function.this_lambda_function_version
}

module "deploy" {
  source = "../../modules/deploy"

  alias_name    = module.alias_refresh.this_lambda_alias_name
  function_name = module.lambda_function.this_lambda_function_name

  target_version = module.lambda_function.this_lambda_function_version
  description    = "This is my awesome deploy!"

  create_app = true
  app_name   = "my-awesome-app"

  create_deployment_group = true
  deployment_group_name   = "something"

  create_deployment          = true
  save_deploy_script         = true
  wait_deployment_completion = true
  force_deploy               = true

  attach_triggers_policy = true
  triggers = {
    start = {
      events     = ["DeploymentStart"]
      name       = "DeploymentStart"
      target_arn = aws_sns_topic.sns1.arn
    }
    success = {
      events     = ["DeploymentSuccess"]
      name       = "DeploymentSuccess"
      target_arn = aws_sns_topic.sns2.arn
    }
  }

}

resource "aws_sns_topic" "sns1" {
  name_prefix = random_pet.this.id
}

resource "aws_sns_topic" "sns2" {
  name_prefix = random_pet.this.id
}
