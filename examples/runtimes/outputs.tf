output "rust_lambda_function_url" {
  description = "The URL of the Lambda Function in Rust"
  value       = module.rust_lambda_function.lambda_function_url
}

output "go_lambda_function_url" {
  description = "The URL of the Lambda Function in Go"
  value       = module.go_lambda_function.lambda_function_url
}

output "java21_lambda_function_arn" {
  description = "The ARN of the Lambda Function in Java 21"
  value       = module.java21_lambda_function.lambda_function_arn
}

output "lambda_function_result" {
  description = "The results of the Lambda Function calls"
  value       = { for k, v in data.aws_lambda_invocation.this : k => jsondecode(v.result) }
}

output "lambda_function_status_codes" {
  description = "The status codes of the Lambda Function calls"
  value       = { for k, v in data.http.this : k => v.status_code }
}
