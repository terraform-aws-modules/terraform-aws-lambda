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

  function_name           = random_pet.this.id
  handler                 = "index.lambda_handler"
  runtime                 = "python3.12"
  code_signing_config_arn = aws_lambda_code_signing_config.this.arn
  create_package          = false

  s3_existing_package = {
    bucket = aws_signer_signing_job.this.signed_object[0].s3[0].bucket
    key    = aws_signer_signing_job.this.signed_object[0].s3[0].key
  }
}

################################################################################
# Lambda Code Signing
################################################################################

resource "aws_s3_object" "unsigned" {
  bucket = module.s3_bucket.s3_bucket_id
  key    = "unsigned/existing_package.zip"
  source = "${path.module}/../fixtures/python-zip/existing_package.zip"

  # Making sure that S3 versioning configuration is propagated properly
  depends_on = [
    module.s3_bucket
  ]
}

resource "aws_signer_signing_profile" "this" {
  platform_id = "AWSLambda-SHA384-ECDSA"
  # invalid value for name (must be alphanumeric with max length of 64 characters)
  name = replace(random_pet.this.id, "-", "")

  signature_validity_period {
    value = 3
    type  = "MONTHS"
  }
}

resource "aws_signer_signing_job" "this" {
  profile_name = aws_signer_signing_profile.this.name

  source {
    s3 {
      bucket  = module.s3_bucket.s3_bucket_id
      key     = aws_s3_object.unsigned.id
      version = aws_s3_object.unsigned.version_id
    }
  }

  destination {
    s3 {
      bucket = module.s3_bucket.s3_bucket_id
      prefix = "signed/"
    }
  }

  ignore_signing_job_failure = true
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
