provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something

  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

data "aws_availability_zones" "available" {}

data "aws_organizations_organization" "this" {}

locals {
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
}

####################################################
# Lambda Function with event source mapping
####################################################

module "lambda_function" {
  source = "../../"

  function_name = "${random_pet.this.id}-lambda-event-source-mapping"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"

  source_path = "${path.module}/../fixtures/python-app1/index.py"

  event_source_mapping = {
    sqs = {
      event_source_arn        = aws_sqs_queue.this.arn
      function_response_types = ["ReportBatchItemFailures"]
      scaling_config = {
        maximum_concurrency = 20
      }
      metrics_config = {
        metrics = ["EventCount"]
      }
    }
    dynamodb = {
      event_source_arn           = aws_dynamodb_table.this.stream_arn
      starting_position          = "LATEST"
      destination_arn_on_failure = aws_sqs_queue.failure.arn
      filter_criteria = [
        {
          pattern = jsonencode({
            eventName : ["INSERT"]
          })
        },
        {
          pattern = jsonencode({
            data : {
              Temperature : [{ numeric : [">", 0, "<=", 100] }]
              Location : ["Oslo"]
            }
          })
        }
      ]
    }
    kinesis = {
      event_source_arn  = aws_kinesis_stream.this.arn
      starting_position = "LATEST"
      filter_criteria = {
        pattern = jsonencode({
          data : {
            Temperature : [{ numeric : [">", 0, "<=", 100] }]
            Location : ["Oslo"]
          }
        })
      }
    }
    mq = {
      event_source_arn = aws_mq_broker.this.arn
      queues           = ["my-queue"]
      source_access_configuration = [
        {
          type = "BASIC_AUTH"
          uri  = aws_secretsmanager_secret.this.arn
        },
        {
          type = "VIRTUAL_HOST"
          uri  = "/"
        }
      ]
      tags = { mapping = "amq" }
    }
    #    self_managed_kafka = {
    #      batch_size        = 1
    #      starting_position = "TRIM_HORIZON"
    #      topics            = ["topic1", "topic2"]
    #      self_managed_event_source = [
    #        {
    #          endpoints = {
    #            KAFKA_BOOTSTRAP_SERVERS = "kafka1.example.com:9092,kafka2.example.com:9092"
    #          }
    #        }
    #      ]
    #      self_managed_kafka_event_source_config = [
    #        {
    #          consumer_group_id = "example-consumer-group"
    #        }
    #      ]
    #      source_access_configuration = [
    #        {
    #          type = "SASL_SCRAM_512_AUTH",
    #          uri  = "SECRET_AUTH_INFO"
    #        },
    #        {
    #          type = "VPC_SECURITY_GROUP",
    #          uri  = "security_group:sg-12345678"
    #        },
    #        {
    #          type = "VPC_SUBNET"
    #          uri  = "subnet:subnet-12345678"
    #        }
    #      ]
    #    }
  }

  allowed_triggers = {
    config = {
      principal        = "config.amazonaws.com"
      principal_org_id = data.aws_organizations_organization.this.id
    }
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
    mq = {
      principal  = "mq.amazonaws.com"
      source_arn = aws_mq_broker.this.arn
    }
  }

  create_current_version_allowed_triggers = false

  attach_network_policy = true

  attach_policy_statements = true
  policy_statements = {
    # Allow failures to be sent to SQS queue
    sqs_failure = {
      effect    = "Allow",
      actions   = ["sqs:SendMessage"],
      resources = [aws_sqs_queue.failure.arn]
    },
    # Execution role permissions to read records from an Amazon MQ broker
    # https://docs.aws.amazon.com/lambda/latest/dg/with-mq.html#events-mq-permissions
    mq_event_source = {
      effect    = "Allow",
      actions   = ["ec2:DescribeSubnets", "ec2:DescribeSecurityGroups", "ec2:DescribeVpcs"],
      resources = ["*"]
    },
    mq_describe_broker = {
      effect    = "Allow",
      actions   = ["mq:DescribeBroker"],
      resources = [aws_mq_broker.this.arn]
    },
    secrets_manager_get_value = {
      effect    = "Allow",
      actions   = ["secretsmanager:GetSecretValue"],
      resources = [aws_secretsmanager_secret.this.arn]
    }
  }

  attach_policies    = true
  number_of_policies = 3

  policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaKinesisExecutionRole",
  ]

  tags = {
    example = "event-source-mapping"
  }
}

##################
# Extra resources
##################

# Shared resources
resource "random_pet" "this" {
  length = 2
}

resource "random_password" "this" {
  length  = 40
  special = false
}

# SQS
resource "aws_sqs_queue" "this" {
  name = random_pet.this.id
}

resource "aws_sqs_queue" "failure" {
  name = "${random_pet.this.id}-failure"
}

# DynamoDB
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

# Kinesis
resource "aws_kinesis_stream" "this" {
  name        = random_pet.this.id
  shard_count = 1
}

# Amazon MQ
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = random_pet.this.id
  cidr = local.vpc_cidr

  azs            = local.azs
  public_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]

  enable_nat_gateway = false
}

resource "aws_mq_broker" "this" {
  broker_name        = random_pet.this.id
  engine_type        = "RabbitMQ"
  engine_version     = "3.12.13"
  host_instance_type = "mq.t3.micro"
  security_groups    = [module.vpc.default_security_group_id]
  subnet_ids         = slice(module.vpc.public_subnets, 0, 1)

  user {
    username = random_pet.this.id
    password = random_password.this.result
  }
}

resource "aws_secretsmanager_secret" "this" {
  name = "${random_pet.this.id}-mq-credentials"
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id
  secret_string = jsonencode({
    username = random_pet.this.id
    password = random_password.this.result
  })
}
