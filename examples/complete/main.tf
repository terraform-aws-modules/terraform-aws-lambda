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
# Lambda Function (building locally, storing on S3,
# set allowed triggers, set policies)
####################################################

module "lambda_function" {
  source = "../../"

  function_name = "${random_pet.this.id}-lambda1"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  publish       = true

  source_path = "${path.module}/../fixtures/python3.8-app1"

  store_on_s3 = true
  s3_bucket   = module.s3_bucket.this_s3_bucket_id

  layers = [
    module.lambda_layer_local.this_lambda_layer_arn,
    module.lambda_layer_s3.this_lambda_layer_arn,
  ]

  environment_variables = {
    Hello      = "World"
    Serverless = "Terraform"
  }

  dead_letter_target_arn    = aws_sqs_queue.dlq.arn
  attach_dead_letter_policy = true

  allowed_triggers = {
    APIGatewayAny = {
      service = "apigateway"
      arn     = "arn:aws:execute-api:eu-west-1:135367859851:aqnku8akd0"
    },
    APIGatewayDevPost = {
      service    = "apigateway"
      source_arn = "arn:aws:execute-api:eu-west-1:135367859851:aqnku8akd0/dev/POST/*"
    },
    OneRule = {
      principal  = "events.amazonaws.com"
      source_arn = "arn:aws:events:eu-west-1:135367859851:rule/RunDaily"
    }
  }

  ######################
  # Additional policies
  ######################

  policy_json = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "xray:GetSamplingStatisticSummaries"
            ],
            "Resource": ["*"]
        }
    ]
}
EOF

  policy   = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
  policies = ["arn:aws:iam::aws:policy/AWSXrayReadOnlyAccess"]

  policy_statements = {
    dynamodb = {
      effect    = "Allow",
      actions   = ["dynamodb:BatchWriteItem"],
      resources = ["arn:aws:dynamodb:eu-west-1:052212379155:table/Test"]
    },
    s3_read = {
      effect    = "Deny",
      actions   = ["s3:HeadObject", "s3:GetObject"],
      resources = ["arn:aws:s3:::my-bucket/*"]
    }
  }

  ###########################
  # END: Additional policies
  ###########################

  tags = {
    Module = "lambda1"
  }
}

##########################################################
# Lambda Function (deploying existing package from local)
##########################################################

module "lambda_function_existing_package_local" {
  source = "../../"

  function_name = "${random_pet.this.id}-lambda-existing-package-local"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  publish       = true

  create_package         = false
  local_existing_package = "${path.module}/../fixtures/python3.8-zip/existing_package.zip"
  //  s3_existing_package = {
  //    bucket = "humane-bear-bucket"
  //    key = "builds/506df8bef5a4fb01883cce3673c9ff0ed88fb52e8583410e0cca7980a72211a0.zip"
  //    version_id = null
  //  }

  layers = [
    module.lambda_layer_local.this_lambda_layer_arn,
    module.lambda_layer_s3.this_lambda_layer_arn,
  ]
}

#################################
# Lambda Layer (storing locally)
#################################

module "lambda_layer_local" {
  source = "../../"

  create_layer = true

  layer_name          = "${random_pet.this.id}-layer-local"
  description         = "My amazing lambda layer (deployed from local)"
  compatible_runtimes = ["python3.8"]

  source_path = "${path.module}/../fixtures/python3.8-app1"
}

###############################
# Lambda Layer (storing on S3)
###############################

module "lambda_layer_s3" {
  source = "../../"

  create_layer = true

  layer_name          = "${random_pet.this.id}-layer-s3"
  description         = "My amazing lambda layer (deployed from S3)"
  compatible_runtimes = ["python3.8"]

  source_path = "${path.module}/../fixtures/python3.8-app1"

  store_on_s3 = true
  s3_bucket   = module.s3_bucket.this_s3_bucket_id
}

##############
# Lambda@Edge
##############

module "lambda_at_edge" {
  source = "../../"

  lambda_at_edge = true

  function_name = "${random_pet.this.id}-lambda-at-edge"
  description   = "My awesome lambda@edge function"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  source_path = "${path.module}/../fixtures/python3.8-app1"
  hash_extra  = "this string should be included in hash function to produce different filename for the same source" // this is also a build trigger if this changes

  tags = {
    Module = "lambda-at-edge"
  }
}

###############################################
# Lambda Function with provisioned concurrency
###############################################

module "lambda_with_provisioned_concurrency" {
  source = "../../"

  function_name = "${random_pet.this.id}-lambda-provisioned"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  source_path = "${path.module}/../fixtures/python3.8-app1"
  publish     = true

  hash_extra = "hash-extra-lambda-provisioned"

  provisioned_concurrent_executions = 2
}

########################
# Lambda Function alias
########################
//
//data "aws_lambda_function" "existing" {
//  function_name = module.lambda_function.this_lambda_function_name
//}
//
//module "existing_lambda_alias" {
//  source = "../../"
//
//  create_function = false
//  create_package  = false
//  create_alias    = true
//
//  alias_name        = "alias-existing-function"
//  alias_description = "Alias for an existing lambda function"
//
//  alias_function_name    = data.aws_lambda_function.existing.function_name
//  alias_function_version = data.aws_lambda_function.existing.version
//  //  alias_routing_additional_version_weights = {
//  //    "1" = 0.3
//  //  }
//}

###########
# Disabled
###########

module "disabled_lambda" {
  source = "../../"

  create = false
}

##################
# Extra resources
##################

resource "random_pet" "this" {
  length = 2
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket        = "${random_pet.this.id}-bucket"
  force_destroy = true
}

resource "aws_sqs_queue" "dlq" {
  name = random_pet.this.id
}
