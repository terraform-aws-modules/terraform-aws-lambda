provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

####################################################
# Lambda Function with event source mapping
####################################################

module "lambda_function" {
  source = "../../"

  function_name = "${random_pet.this.id}-lambda-event-source-mapping"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  source_path = "${path.module}/../fixtures/python3.8-app1"

  event_source_mapping = {
    sqs = {
      event_source_arn = aws_sqs_queue.this.arn
    }
    dynamodb = {
      event_source_arn           = aws_dynamodb_table.this.stream_arn
      starting_position          = "LATEST"
      destination_arn_on_failure = aws_sqs_queue.failure.arn
    }
    kinesis = {
      event_source_arn  = aws_kinesis_stream.this.arn
      starting_position = "LATEST"
    }
  }

  allowed_triggers = {
    sqs = {
      principal  = "sqs.amazonaws.com"
      source_arn = aws_sqs_queue.this.arn
    }
    dynamodb = {
      principal  = "dynamodb.amazonaws.com"
      source_arn = aws_dynamodb_table.this.stream_arn
    }
    kinesis = {
      principal  = "kinesis.amazonaws.com"
      source_arn = aws_kinesis_stream.this.arn
    }
  }

  create_current_version_allowed_triggers = false

  # Allow failures to be sent to SQS queue
  attach_policy_statements = true
  policy_statements = {
    sqs_failure = {
      effect    = "Allow",
      actions   = ["sqs:SendMessage"],
      resources = [aws_sqs_queue.failure.arn]
    }
  }

  attach_policies    = true
  number_of_policies = 3

  policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaKinesisExecutionRole",
  ]
}

##################
# Extra resources
##################

resource "random_pet" "this" {
  length = 2
}

resource "aws_sqs_queue" "this" {
  name = random_pet.this.id
}

resource "aws_dynamodb_table" "this" {
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

resource "aws_kinesis_stream" "this" {
  name        = random_pet.this.id
  shard_count = 1
}

resource "aws_sqs_queue" "failure" {
  name = "${random_pet.this.id}-failure"
}
