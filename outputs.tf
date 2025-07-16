# Lambda Function
output "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = try(aws_lambda_function.this[0].arn, "")
}

output "lambda_function_arn_static" {
  description = "The static ARN of the Lambda Function. Use this to avoid cycle errors between resources (e.g., Step Functions)"
  value       = local.create && var.create_function && !var.create_layer ? "arn:${data.aws_partition.current.partition}:lambda:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:function:${var.function_name}" : ""
}

output "lambda_function_invoke_arn" {
  description = "The Invoke ARN of the Lambda Function"
  value       = try(aws_lambda_function.this[0].invoke_arn, "")
}

output "lambda_function_name" {
  description = "The name of the Lambda Function"
  value       = try(aws_lambda_function.this[0].function_name, "")
}

output "lambda_function_qualified_arn" {
  description = "The ARN identifying your Lambda Function Version"
  value       = try(aws_lambda_function.this[0].qualified_arn, "")
}

output "lambda_function_qualified_invoke_arn" {
  description = "The Invoke ARN identifying your Lambda Function Version"
  value       = try(aws_lambda_function.this[0].qualified_invoke_arn, "")
}

output "lambda_function_version" {
  description = "Latest published version of Lambda Function"
  value       = try(aws_lambda_function.this[0].version, "")
}

output "lambda_function_last_modified" {
  description = "The date Lambda Function resource was last modified"
  value       = try(aws_lambda_function.this[0].last_modified, "")
}

output "lambda_function_kms_key_arn" {
  description = "The ARN for the KMS encryption key of Lambda Function"
  value       = try(aws_lambda_function.this[0].kms_key_arn, "")
}

output "lambda_function_source_code_hash" {
  description = "Base64-encoded representation of raw SHA-256 sum of the zip file"
  value       = try(aws_lambda_function.this[0].source_code_hash, "")
}

output "lambda_function_source_code_size" {
  description = "The size in bytes of the function .zip file"
  value       = try(aws_lambda_function.this[0].source_code_size, "")
}

output "lambda_function_signing_job_arn" {
  description = "ARN of the signing job"
  value       = try(aws_lambda_function.this[0].signing_job_arn, "")
}

output "lambda_function_signing_profile_version_arn" {
  description = "ARN of the signing profile version"
  value       = try(aws_lambda_function.this[0].signing_profile_version_arn, "")
}

# Lambda Function URL
output "lambda_function_url" {
  description = "The URL of the Lambda Function URL"
  value       = try(aws_lambda_function_url.this[0].function_url, "")
}

output "lambda_function_url_id" {
  description = "The Lambda Function URL generated id"
  value       = try(aws_lambda_function_url.this[0].url_id, "")
}

# Lambda Layer
output "lambda_layer_arn" {
  description = "The ARN of the Lambda Layer with version"
  value       = try(aws_lambda_layer_version.this[0].arn, "")
}

output "lambda_layer_layer_arn" {
  description = "The ARN of the Lambda Layer without version"
  value       = try(aws_lambda_layer_version.this[0].layer_arn, "")
}

output "lambda_layer_created_date" {
  description = "The date Lambda Layer resource was created"
  value       = try(aws_lambda_layer_version.this[0].created_date, "")
}

output "lambda_layer_source_code_size" {
  description = "The size in bytes of the Lambda Layer .zip file"
  value       = try(aws_lambda_layer_version.this[0].source_code_size, "")
}

output "lambda_layer_version" {
  description = "The Lambda Layer version"
  value       = try(aws_lambda_layer_version.this[0].version, "")
}

# Lambda Event Source Mapping
output "lambda_event_source_mapping_arn" {
  description = "The event source mapping ARN"
  value       = { for k, v in aws_lambda_event_source_mapping.this : k => v.arn }
}

output "lambda_event_source_mapping_function_arn" {
  description = "The the ARN of the Lambda function the event source mapping is sending events to"
  value       = { for k, v in aws_lambda_event_source_mapping.this : k => v.function_arn }
}

output "lambda_event_source_mapping_state" {
  description = "The state of the event source mapping"
  value       = { for k, v in aws_lambda_event_source_mapping.this : k => v.state }
}

output "lambda_event_source_mapping_state_transition_reason" {
  description = "The reason the event source mapping is in its current state"
  value       = { for k, v in aws_lambda_event_source_mapping.this : k => v.state_transition_reason }
}

output "lambda_event_source_mapping_uuid" {
  description = "The UUID of the created event source mapping"
  value       = { for k, v in aws_lambda_event_source_mapping.this : k => v.uuid }
}

# IAM Role
output "lambda_role_arn" {
  description = "The ARN of the IAM role created for the Lambda Function"
  value       = try(aws_iam_role.lambda[0].arn, "")
}

output "lambda_role_name" {
  description = "The name of the IAM role created for the Lambda Function"
  value       = try(aws_iam_role.lambda[0].name, "")
}

output "lambda_role_unique_id" {
  description = "The unique id of the IAM role created for the Lambda Function"
  value       = try(aws_iam_role.lambda[0].unique_id, "")
}

# CloudWatch Log Group
output "lambda_cloudwatch_log_group_arn" {
  description = "The ARN of the Cloudwatch Log Group"
  value       = local.log_group_arn
}

output "lambda_cloudwatch_log_group_name" {
  description = "The name of the Cloudwatch Log Group"
  value       = local.log_group_name
}

# Deployment package
output "local_filename" {
  description = "The filename of zip archive deployed (if deployment was from local)"
  value       = local.filename

  depends_on = [
    null_resource.archive,
  ]
}

output "s3_object" {
  description = "The map with S3 object data of zip archive deployed (if deployment was from S3)"
  value = {
    bucket     = local.s3_bucket
    key        = local.s3_key
    version_id = local.s3_object_version
  }
}
