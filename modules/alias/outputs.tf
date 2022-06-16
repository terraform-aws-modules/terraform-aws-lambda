# Lambda Alias
output "lambda_alias_name" {
  description = "The name of the Lambda Function Alias"
  value       = try(data.aws_lambda_alias.existing[0].name, aws_lambda_alias.with_refresh[0].name, aws_lambda_alias.no_refresh[0].name, "")
}

output "lambda_alias_arn" {
  description = "The ARN of the Lambda Function Alias"
  value       = try(data.aws_lambda_alias.existing[0].arn, aws_lambda_alias.with_refresh[0].arn, aws_lambda_alias.no_refresh[0].arn, "")
}

output "lambda_alias_invoke_arn" {
  description = "The ARN to be used for invoking Lambda Function from API Gateway"
  value       = try(data.aws_lambda_alias.existing[0].invoke_arn, aws_lambda_alias.with_refresh[0].invoke_arn, aws_lambda_alias.no_refresh[0].invoke_arn, "")
}

output "lambda_alias_description" {
  description = "Description of alias"
  value       = try(data.aws_lambda_alias.existing[0].description, aws_lambda_alias.with_refresh[0].description, aws_lambda_alias.no_refresh[0].description, "")
}

output "lambda_alias_function_version" {
  description = "Lambda function version which the alias uses"
  value       = try(data.aws_lambda_alias.existing[0].function_version, aws_lambda_alias.with_refresh[0].function_version, aws_lambda_alias.no_refresh[0].function_version, "")
}

output "lambda_alias_event_source_mapping_function_arn" {
  description = "The the ARN of the Lambda function the event source mapping is sending events to"
  value       = { for k, v in aws_lambda_event_source_mapping.this : k => v.function_arn }
}

output "lambda_alias_event_source_mapping_state" {
  description = "The state of the event source mapping"
  value       = { for k, v in aws_lambda_event_source_mapping.this : k => v.state }
}

output "lambda_alias_event_source_mapping_state_transition_reason" {
  description = "The reason the event source mapping is in its current state"
  value       = { for k, v in aws_lambda_event_source_mapping.this : k => v.state_transition_reason }
}

output "lambda_alias_event_source_mapping_uuid" {
  description = "The UUID of the created event source mapping"
  value       = { for k, v in aws_lambda_event_source_mapping.this : k => v.uuid }
}
