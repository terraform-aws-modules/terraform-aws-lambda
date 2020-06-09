# Lambda Alias
output "this_lambda_alias_name" {
  description = "The name of the Lambda Function Alias"
  value       = element(concat(data.aws_lambda_alias.existing.*.name, aws_lambda_alias.with_refresh.*.name, aws_lambda_alias.no_refresh.*.name, [""]), 0)
}

output "this_lambda_alias_arn" {
  description = "The ARN of the Lambda Function Alias"
  value       = element(concat(data.aws_lambda_alias.existing.*.arn, aws_lambda_alias.with_refresh.*.arn, aws_lambda_alias.no_refresh.*.arn, [""]), 0)
}

output "this_lambda_alias_invoke_arn" {
  description = "The ARN to be used for invoking Lambda Function from API Gateway"
  value       = element(concat(data.aws_lambda_alias.existing.*.invoke_arn, aws_lambda_alias.with_refresh.*.invoke_arn, aws_lambda_alias.no_refresh.*.invoke_arn, [""]), 0)
}

output "this_lambda_alias_description" {
  description = "Description of alias"
  value       = element(concat(data.aws_lambda_alias.existing.*.description, aws_lambda_alias.with_refresh.*.description, aws_lambda_alias.no_refresh.*.description, [""]), 0)
}

output "this_lambda_alias_function_version" {
  description = "Lambda function version which the alias uses"
  value       = element(concat(data.aws_lambda_alias.existing.*.function_version, aws_lambda_alias.with_refresh.*.function_version, aws_lambda_alias.no_refresh.*.function_version, [""]), 0)
}
