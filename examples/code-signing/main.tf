locals {
  lambda_s3_bucket     = "hello-world-lambda-s3-bucket"
  lambda_zip_filename  = "lambda.zip"
  lambda_function_name = "hello-world-lambda"
}

# create a s3 bucket to store signed code
module "lambda_s3_bucket" {
  source                  = "terraform-aws-modules/s3-bucket/aws"
  bucket                  = local.lambda_s3_bucket
  acl                     = "private"
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

# create a signing profile
resource "aws_signer_signing_profile" "lambda_signing_profile" {
  # aws signer list-signing-platforms | jq '.platforms[].platformId'
  platform_id = "AWSLambda-SHA384-ECDSA"
  name        = "lambda_signing_profile"

  signature_validity_period {
    value = 3
    type  = "MONTHS"
  }
}

# upload zipped lambda code to s3
data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "dist"
  output_path = local.lambda_zip_filename
}

resource "aws_s3_bucket_object" "lambda" {
  bucket = module.lambda_s3_bucket.s3_bucket_id
  key    = "unsigned/${data.archive_file.lambda.output_path}"
  source = data.archive_file.lambda.output_path
}

# code signing job
resource "aws_signer_signing_job" "build_signing_job" {
  profile_name = aws_signer_signing_profile.lambda_signing_profile.name

  source {
    s3 {
      bucket  = module.lambda_s3_bucket.s3_bucket_id
      key     = "unsigned/${local.lambda_zip_filename}"
      version = aws_s3_bucket_object.lambda.version_id
    }
  }

  destination {
    s3 {
      bucket = module.lambda_s3_bucket.s3_bucket_id
      prefix = "signed/"
    }
  }

  ignore_signing_job_failure = true

  depends_on = [
    aws_s3_bucket_object.lambda
  ]
}

resource "aws_lambda_code_signing_config" "lambda" {
  allowed_publishers {
    signing_profile_version_arns = [aws_signer_signing_profile.lambda_signing_profile.version_arn]
  }
  policies {
    untrusted_artifact_on_deployment = "Enforce"
  }
}

module "lambda" {
  source = "../../"

  function_name           = local.lambda_function_name
  handler                 = "lambda.lambda_handler"
  runtime                 = "python3.8"
  code_signing_config_arn = aws_lambda_code_signing_config.lambda.arn
  create_package          = false
  s3_existing_package = {
    bucket = module.lambda_s3_bucket.s3_bucket_id
    key    = "signed/${aws_signer_signing_job.build_signing_job.id}.zip"
  }
}
