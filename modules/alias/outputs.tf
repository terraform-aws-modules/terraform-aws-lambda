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
