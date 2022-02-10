# Lambda Function
output "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = module.lambda.lambda_function_arn
}

output "lambda_function_invoke_arn" {
  description = "The Invoke ARN of the Lambda Function"
  value       = module.lambda.lambda_function_invoke_arn
}
