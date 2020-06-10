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
  hash_extra  = "yo"

  create_async_event_config    = true
  maximum_event_age_in_seconds = 100

  provisioned_concurrent_executions = 1

  allowed_triggers = {
    APIGatewayAny = {
      service = "apigateway"
      arn     = "arn:aws:execute-api:eu-west-1:135367859851:aqnku8akd0"
    }
  }

  // current version
  //  create_current_version_async_event_config = false
  //  create_current_version_triggers = false

  // unqualified alias
  //  create_unqualified_alias_async_event_config = false
  //  create_unqualified_alias_triggers = false
}

module "alias_no_refresh" {
  source = "../../modules/alias"

  create        = true
  refresh_alias = false

  name = "current-no-refresh"

  function_name    = module.lambda_function.this_lambda_function_name
  function_version = module.lambda_function.this_lambda_function_version

  //  create_version_async_event_config = false
  //  create_async_event_config = true
  //  maximum_event_age_in_seconds = 130

  allowed_triggers = {
    AnotherAPIGatewayAny = { // keys should be unique
      service = "apigateway"
      arn     = "arn:aws:execute-api:eu-west-1:135367859851:abcdedfgse"
    }
  }

}

module "alias_refresh" {
  source = "../../modules/alias"

  create        = true
  refresh_alias = true

  name = "current-with-refresh"

  function_name = module.lambda_function.this_lambda_function_name
}

module "alias_existing" {
  source = "../../modules/alias"

  create             = true
  use_existing_alias = true

  name          = module.alias_refresh.this_lambda_alias_name
  function_name = module.lambda_function.this_lambda_function_name

  create_async_event_config    = true
  maximum_event_age_in_seconds = 100

  allowed_triggers = {
    ThirdAPIGatewayAny = {
      service = "apigateway"
      arn     = "arn:aws:execute-api:eu-west-1:135367859851:aqnku8akd0"
    }
  }

}
