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

module "lambda_function1" {
  source = "../../"

  function_name = "${random_pet.this.id}-lambda1"
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

module "lambda_function2" {
  source = "../../"

  function_name = "${random_pet.this.id}-lambda2"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  publish       = true

  source_path = "${path.module}/../fixtures/python3.8-app1"
  hash_extra  = "yo2"

  allowed_triggers = {
    APIGatewayAny = {
      service = "apigateway"
      arn     = "arn:aws:execute-api:eu-west-1:135367859851:aqnku8akd0"
    }
  }
}

module "alias_refresh1" {
  source = "../../modules/alias"

  refresh_alias = true

  name = "current-with-refresh1"

  function_name = module.lambda_function1.this_lambda_function_name

  # Set function_version when creating alias to be able to deploy using it,
  # because AWS CodeDeploy doesn't understand $LATEST as CurrentVersion.
  function_version = module.lambda_function1.this_lambda_function_version
}

module "alias_refresh2" {
  source = "../../modules/alias"

  refresh_alias = true

  name = "current-with-refresh2"

  function_name = module.lambda_function2.this_lambda_function_name

  # Set function_version when creating alias to be able to deploy using it,
  # because AWS CodeDeploy doesn't understand $LATEST as CurrentVersion.
  function_version = module.lambda_function2.this_lambda_function_version
}

module "deploy" {
  source = "../../modules/deploy"

  alias_name    = module.alias_refresh1.this_lambda_alias_name
  function_name = module.lambda_function1.this_lambda_function_name

  target_version = module.lambda_function1.this_lambda_function_version

  create_app            = true
  app_name              = "my-awesome-app"
  deployment_group_name = "something"

  create_deployment = true

  //  before_allow_traffic_hook_arn = "arn1"
  //  after_allow_traffic_hook_arn = "arn2"

}
