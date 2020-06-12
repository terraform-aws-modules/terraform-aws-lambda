# Lambda Function
output "this_lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = element(concat(aws_lambda_function.this.*.arn, [""]), 0)
}

output "this_lambda_function_invoke_arn" {
  description = "The Invoke ARN of the Lambda Function"
  value       = element(concat(aws_lambda_function.this.*.invoke_arn, [""]), 0)
}

output "this_lambda_function_name" {
  description = "The name of the Lambda Function"
  value       = element(concat(aws_lambda_function.this.*.function_name, [""]), 0)
}

output "this_lambda_function_qualified_arn" {
  description = "The ARN identifying your Lambda Function Version"
  value       = element(concat(aws_lambda_function.this.*.qualified_arn, [""]), 0)
}

output "this_lambda_function_version" {
  description = "Latest published version of Lambda Function"
  value       = element(concat(aws_lambda_function.this.*.version, [""]), 0)
}

output "this_lambda_function_last_modified" {
  description = "The date Lambda Function resource was last modified"
  value       = element(concat(aws_lambda_function.this.*.last_modified, [""]), 0)
}

output "this_lambda_function_kms_key_arn" {
  description = "The ARN for the KMS encryption key of Lambda Function"
  value       = element(concat(aws_lambda_function.this.*.kms_key_arn, [""]), 0)
}

output "this_lambda_function_source_code_hash" {
  description = "Base64-encoded representation of raw SHA-256 sum of the zip file"
  value       = element(concat(aws_lambda_function.this.*.source_code_hash, [""]), 0)
}

output "this_lambda_function_source_code_size" {
  description = "The size in bytes of the function .zip file"
  value       = element(concat(aws_lambda_function.this.*.source_code_size, [""]), 0)
}

# Lambda Layer
output "this_lambda_layer_arn" {
  description = "The ARN of the Lambda Layer with version"
  value       = element(concat(aws_lambda_layer_version.this.*.arn, [""]), 0)
}

output "this_lambda_layer_layer_arn" {
  description = "The ARN of the Lambda Layer without version"
  value       = element(concat(aws_lambda_layer_version.this.*.layer_arn, [""]), 0)
}

output "this_lambda_layer_created_date" {
  description = "The date Lambda Layer resource was created"
  value       = element(concat(aws_lambda_layer_version.this.*.created_date, [""]), 0)
}

output "this_lambda_layer_source_code_size" {
  description = "The size in bytes of the Lambda Layer .zip file"
  value       = element(concat(aws_lambda_layer_version.this.*.source_code_size, [""]), 0)
}

output "this_lambda_layer_version" {
  description = "The Lambda Layer version"
  value       = element(concat(aws_lambda_layer_version.this.*.version, [""]), 0)
}

# IAM Role
output "lambda_role_arn" {
  description = "The ARN of the IAM role created for the Lambda Function"
  value       = element(concat(aws_iam_role.lambda.*.arn, [""]), 0)
}

output "lambda_role_name" {
  description = "The name of the IAM role created for the Lambda Function"
  value       = element(concat(aws_iam_role.lambda.*.name, [""]), 0)
}

# CloudWatch Log Group
output "lambda_cloudwatch_log_group_arn" {
  description = "The ARN of the Cloudwatch Log Group"
  value       = local.log_group_arn
}

# Deployment package
output "local_filename" {
  description = "The filename of zip archive deployed (if deployment was from local)"
  value       = local.filename
}

output "s3_object" {
  description = "The map with S3 object data of zip archive deployed (if deployment was from S3)"
  value       = map("bucket", local.s3_bucket, "key", local.s3_key, "version_id", local.s3_object_version)
}
