output "lambda_function_signing_job_arn" {
  description = "ARN of the signing job"
  value       = module.lambda.lambda_function_signing_job_arn
}

output "lambda_function_signing_profile_version_arn" {
  description = "ARN of the signing profile version"
  value       = module.lambda.lambda_function_signing_profile_version_arn
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = module.lambda.lambda_function_arn
}

output "lambda_function_invoke_arn" {
  description = "The Invoke ARN of the Lambda Function"
  value       = module.lambda.lambda_function_invoke_arn
}
