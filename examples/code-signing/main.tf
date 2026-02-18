locals {
  lambda_code_signing_profile_name = replace(random_pet.this.id, "-", "")
}
provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

################################################################################
# Lambda Function
################################################################################

module "lambda" {
  source = "../../"

  function_name                    = random_pet.this.id
  handler                          = "index.lambda_handler"
  runtime                          = "python3.12"
  create_package                   = true
  enable_code_signing              = true
  code_signing_config_arn          = aws_lambda_code_signing_config.this.arn
  lambda_code_signing_profile_name = local.lambda_code_signing_profile_name
  s3_signing_prefix                = "signed/"

  source_path = "${path.module}/../fixtures/python-app1"

  store_on_s3 = true
  s3_bucket   = module.s3_bucket.s3_bucket_id
  s3_prefix   = "lambda-builds/"

  s3_object_override_default_tags = true
  s3_object_tags = {
    S3ObjectName = "lambda1"
    Override     = "true"
  }
}

# ################################################################################
# # Lambda Code Signing
# ################################################################################

resource "aws_signer_signing_profile" "this" {
  platform_id = "AWSLambda-SHA384-ECDSA"
  # invalid value for name (must be alphanumeric with max length of 64 characters)
  name = local.lambda_code_signing_profile_name

  signature_validity_period {
    value = 3
    type  = "MONTHS"
  }
}

resource "aws_lambda_code_signing_config" "this" {
  allowed_publishers {
    signing_profile_version_arns = [aws_signer_signing_profile.this.version_arn]
  }

  policies {
    untrusted_artifact_on_deployment = "Enforce"
  }
}

################################################################################
# Supporting Resources
################################################################################

resource "random_pet" "this" {
  length = 2
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket_prefix = "${random_pet.this.id}-"
  force_destroy = true

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}
