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

  function_name = "${random_pet.this.id}-lambda-event-source-mapping"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  source_path = "${path.module}/../fixtures/python3.8-app1"

  attach_policies    = true
  number_of_policies = 2

  event_source_mapping = {
    sqs = {
      event_source_arn = aws_sqs_queue.one.arn
    }
    dynamodb = {
      event_source_arn = aws_dynamodb_table.two.stream_arn
    }
  }

  allowed_triggers = {
    sqs = {
      principal  = "sqs.amazonaws.com"
      source_arn = aws_sqs_queue.one.arn
    }
    dynamodb = {
      principal  = "dynamodb.amazonaws.com"
      source_arn = aws_dynamodb_table.two.stream_arn
    }
  }

  policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole"
  ]
}

resource "aws_sqs_queue" "one" {
  name_prefix = random_pet.this.id
}

resource "aws_dynamodb_table" "two" {
  name             = random_pet.this.id
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "UserId"
  range_key        = "GameTitle"
  stream_view_type = "NEW_AND_OLD_IMAGES"
  stream_enabled   = true

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }
}

