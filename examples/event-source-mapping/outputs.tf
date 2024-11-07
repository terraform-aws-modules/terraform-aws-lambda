# Lambda Function
output "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = module.lambda_function.lambda_function_arn
}

output "lambda_function_arn_static" {
  description = "The static ARN of the Lambda Function. Use this to avoid cycle errors between resources (e.g., Step Functions)"
  value       = module.lambda_function.lambda_function_arn_static
}

output "lambda_function_invoke_arn" {
  description = "The Invoke ARN of the Lambda Function"
  value       = module.lambda_function.lambda_function_invoke_arn
}

output "lambda_function_name" {
  description = "The name of the Lambda Function"
  value       = module.lambda_function.lambda_function_name
}

output "lambda_function_qualified_arn" {
  description = "The ARN identifying your Lambda Function Version"
  value       = module.lambda_function.lambda_function_qualified_arn
}

output "lambda_function_version" {
  description = "Latest published version of Lambda Function"
  value       = module.lambda_function.lambda_function_version
}

output "lambda_function_last_modified" {
  description = "The date Lambda Function resource was last modified"
  value       = module.lambda_function.lambda_function_last_modified
}

output "lambda_function_kms_key_arn" {
  description = "The ARN for the KMS encryption key of Lambda Function"
  value       = module.lambda_function.lambda_function_kms_key_arn
}

output "lambda_function_source_code_hash" {
  description = "Base64-encoded representation of raw SHA-256 sum of the zip file"
  value       = module.lambda_function.lambda_function_source_code_hash
}

output "lambda_function_source_code_size" {
  description = "The size in bytes of the function .zip file"
  value       = module.lambda_function.lambda_function_source_code_size
}

# Lambda Event Source Mapping
output "lambda_event_source_mapping_function_arn" {
  description = "The the ARN of the Lambda function the event source mapping is sending events to"
  value       = module.lambda_function.lambda_event_source_mapping_function_arn
}

output "lambda_event_source_mapping_state" {
  description = "The state of the event source mapping"
  value       = module.lambda_function.lambda_event_source_mapping_state
}

output "lambda_event_source_mapping_state_transition_reason" {
  description = "The reason the event source mapping is in its current state"
  value       = module.lambda_function.lambda_event_source_mapping_state_transition_reason
}

output "lambda_event_source_mapping_uuid" {
  description = "The UUID of the created event source mapping"
  value       = module.lambda_function.lambda_event_source_mapping_uuid
}

output "lambda_event_source_mapping_arn" {
  description = "The event source mapping ARN"
  value       = module.lambda_function.lambda_event_source_mapping_arn
}
