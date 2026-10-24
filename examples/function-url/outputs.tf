output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = module.lambda_function.lambda_function_name
}

output "lambda_function_url" {
  description = "The IAM-authenticated URL of the unqualified Lambda function"
  value       = module.lambda_function.lambda_function_url
}

output "lambda_alias_name" {
  description = "The name of the Lambda alias"
  value       = module.alias.lambda_alias_name
}

output "lambda_alias_url" {
  description = "The IAM-authenticated URL of the Lambda alias"
  value       = aws_lambda_function_url.alias.function_url
}

output "invoker_role_arn" {
  description = "The role to assume when testing invocation through the function URLs"
  value       = aws_iam_role.invoker.arn
}
