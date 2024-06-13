provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

data "aws_organizations_organization" "this" {}

resource "random_pet" "this" {
  length = 2
}

module "sqs_events" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "~> 3.0"

  name = "${random_pet.this.id}-events"
}

module "lambda_function" {
  source = "../../"

  function_name = "${random_pet.this.id}-lambda"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"
  publish       = true

  source_path = "${path.module}/../fixtures/python-app1"
  hash_extra  = "yo"

  create_async_event_config    = true
  maximum_event_age_in_seconds = 100

  attach_policies = true
  policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole",
  ]
  number_of_policies = 1

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

  event_source_mapping = {
    sqs = {
      service             = "sqs"
      event_source_arn    = module.sqs_events.sqs_queue_arn
      maximum_concurrency = 10
    }
  }

  allowed_triggers = {
    Config = {
      principal        = "config.amazonaws.com"
      principal_org_id = data.aws_organizations_organization.this.id
    }
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

  event_source_mapping = {
    sqs = {
      service          = "sqs"
      event_source_arn = module.sqs_events.sqs_queue_arn
    }
  }

  allowed_triggers = {
    Config = {
      principal        = "config.amazonaws.com"
      principal_org_id = data.aws_organizations_organization.this.id
    }
    ThirdAPIGatewayAny = {
      service    = "apigateway"
      source_arn = "arn:aws:execute-api:eu-west-1:135367859851:aqnku8akd0/*/*/*"
    }
  }

}
