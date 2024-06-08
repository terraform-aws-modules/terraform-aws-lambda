provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

resource "random_pet" "this" {
  length = 2
}

module "lambda_function" {
  source = "../../"

  function_name = "${random_pet.this.id}-lambda"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"
  publish       = true

  source_path = "${path.module}/../fixtures/python-app1"
  hash_extra  = "yo1"
}

module "alias_refresh" {
  source = "../../modules/alias"

  refresh_alias = true

  name = "current-with-refresh"

  function_name = module.lambda_function.lambda_function_name

  # Set function_version when creating alias to be able to deploy using it,
  # because AWS CodeDeploy doesn't understand $LATEST as CurrentVersion.
  function_version = module.lambda_function.lambda_function_version
}

module "deploy" {
  source = "../../modules/deploy"

  alias_name    = module.alias_refresh.lambda_alias_name
  function_name = module.lambda_function.lambda_function_name

  target_version = module.lambda_function.lambda_function_version
  description    = "This is my awesome deploy!"

  create_app = true
  app_name   = "my-awesome-app"

  create_deployment_group = true
  deployment_group_name   = "something"

  create_deployment          = true
  run_deployment             = true
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
