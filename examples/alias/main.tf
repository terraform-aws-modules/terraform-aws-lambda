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

  provisioned_concurrent_executions = -1

  allowed_triggers = {
    APIGatewayAny = {
      service    = "apigateway"
      source_arn = "arn:aws:execute-api:eu-west-1:135367859851:aqnku8akd0/*/*/*"
    }
  }

  # current version
  #  create_current_version_async_event_config = false
  #  create_current_version_triggers = false

  # unqualified alias
  #  create_unqualified_alias_async_event_config = false
  #  create_unqualified_alias_triggers = false
}

module "alias_no_refresh" {
  source = "../../modules/alias"

  create        = true
  refresh_alias = false

  name = "current-no-refresh"

  function_name    = module.lambda_function.lambda_function_name
  function_version = module.lambda_function.lambda_function_version

  #  create_version_async_event_config = false
  #  create_async_event_config = true
  #  maximum_event_age_in_seconds = 130

  allowed_triggers = {
    AnotherAPIGatewayAny = { # keys should be unique
      service    = "apigateway"
      source_arn = "arn:aws:execute-api:eu-west-1:135367859851:abcdedfgse/*/*/*"
    }
  }

}

module "alias_refresh" {
  source = "../../modules/alias"

  create        = true
  refresh_alias = true

  name = "current-with-refresh"

  function_name = module.lambda_function.lambda_function_name
}

module "alias_existing" {
  source = "../../modules/alias"

  create             = true
  use_existing_alias = true

  name          = module.alias_refresh.lambda_alias_name
  function_name = module.lambda_function.lambda_function_name

  create_async_event_config    = true
  maximum_event_age_in_seconds = 100

  allowed_triggers = {
    ThirdAPIGatewayAny = {
      service    = "apigateway"
      source_arn = "arn:aws:execute-api:eu-west-1:135367859851:aqnku8akd0/*/*/*"
    }
  }

}

module "sqs_events" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "v3.3.0"

  name = "${random_pet.this.id}-events"
}

module "lambda_function_event_mapping" {
  source = "../../"

  function_name = "${random_pet.this.id}-lambda-event-mapping"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  publish       = true

  source_path = "${path.module}/../fixtures/python3.8-app1"
  hash_extra  = "yo"

  provisioned_concurrent_executions = 1

  create_async_event_config    = true
  maximum_event_age_in_seconds = 100

  attach_policies = true
  policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole",
  ]
  number_of_policies = 1
}

module "alias_no_refresh_event_mapping" {
  source = "../../modules/alias"

  create        = true
  refresh_alias = false

  name = "current-no-refresh"

  function_name    = module.lambda_function_event_mapping.lambda_function_name
  function_version = module.lambda_function_event_mapping.lambda_function_version

  event_source_mapping = {
    sqs = {
      service          = "sqs"
      event_source_arn = module.sqs_events.sqs_queue_arn
    }
  }
}
