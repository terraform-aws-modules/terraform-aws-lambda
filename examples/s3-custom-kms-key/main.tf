provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

module "lambda_function" {
  source = "../../"

  function_name = "${random_pet.this.id}-lambda-s3-custom-kms-key"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  source_path   = "${path.module}/../fixtures/python3.8-app1"

  store_on_s3 = true
  s3_bucket   = module.s3_bucket.s3_bucket_id
  s3_prefix   = "lambda-builds/"

  # Upload to S3 using our self-managed KMS key
  s3_kms_key_id = aws_kms_key.objects.arn
}

resource "random_pet" "this" {
  length = 2
}

resource "aws_kms_key" "objects" {
  description             = "KMS key used to encrypt bucket objects"
  deletion_window_in_days = 7
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket_prefix = "${random_pet.this.id}-"
  force_destroy = true

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # Only allow uploads with specific KMS key
  attach_deny_incorrect_kms_key_sse      = true
  allowed_kms_key_arn                    = aws_kms_key.objects.arn
  attach_deny_unencrypted_object_uploads = true

  versioning = {
    enabled = true
  }
}
