## Lambda Function
#output "lambda_function_arn" {
#  description = "The ARN of the Lambda Function"
#  value       = module.lambda_function_from_package.lambda_function_arn
#}
#
#output "lambda_function_invoke_arn" {
#  description = "The Invoke ARN of the Lambda Function"
#  value       = module.lambda_function_from_package.lambda_function_invoke_arn
#}
#
#output "lambda_function_name" {
#  description = "The name of the Lambda Function"
#  value       = module.lambda_function_from_package.lambda_function_name
#}
#
#output "lambda_function_qualified_arn" {
#  description = "The ARN identifying your Lambda Function Version"
#  value       = module.lambda_function_from_package.lambda_function_qualified_arn
#}
#
#output "lambda_function_version" {
#  description = "Latest published version of Lambda Function"
#  value       = module.lambda_function_from_package.lambda_function_version
#}
#
#output "lambda_function_last_modified" {
#  description = "The date Lambda Function resource was last modified"
#  value       = module.lambda_function_from_package.lambda_function_last_modified
#}
#
#output "lambda_function_kms_key_arn" {
#  description = "The ARN for the KMS encryption key of Lambda Function"
#  value       = module.lambda_function_from_package.lambda_function_kms_key_arn
#}
#
#output "lambda_function_source_code_hash" {
#  description = "Base64-encoded representation of raw SHA-256 sum of the zip file"
#  value       = module.lambda_function_from_package.lambda_function_source_code_hash
#}
#
#output "lambda_function_source_code_size" {
#  description = "The size in bytes of the function .zip file"
#  value       = module.lambda_function_from_package.lambda_function_source_code_size
#}
#
## Lambda Layer
#output "lambda_layer_arn" {
#  description = "The ARN of the Lambda Layer with version"
#  value       = module.lambda_function_from_package.lambda_layer_arn
#}
#
#output "lambda_layer_layer_arn" {
#  description = "The ARN of the Lambda Layer without version"
#  value       = module.lambda_function_from_package.lambda_layer_layer_arn
#}
#
#output "lambda_layer_created_date" {
#  description = "The date Lambda Layer resource was created"
#  value       = module.lambda_function_from_package.lambda_layer_created_date
#}
#
#output "lambda_layer_source_code_size" {
#  description = "The size in bytes of the Lambda Layer .zip file"
#  value       = module.lambda_function_from_package.lambda_layer_source_code_size
#}
#
#output "lambda_layer_version" {
#  description = "The Lambda Layer version"
#  value       = module.lambda_function_from_package.lambda_layer_version
#}
#
## IAM Role
#output "lambda_role_arn" {
#  description = "The ARN of the IAM role created for the Lambda Function"
#  value       = module.lambda_function_from_package.lambda_role_arn
#}
#
#output "lambda_role_name" {
#  description = "The name of the IAM role created for the Lambda Function"
#  value       = module.lambda_function_from_package.lambda_role_name
#}
#
## CloudWatch Log Group
#output "lambda_cloudwatch_log_group_arn" {
#  description = "The ARN of the Cloudwatch Log Group"
#  value       = module.lambda_function_from_package.lambda_cloudwatch_log_group_arn
#}
#
## Deployment package
#output "local_filename" {
#  description = "The filename of zip archive deployed (if deployment was from local)"
#  value       = module.lambda_function_from_package.local_filename
#}
#
#output "s3_object" {
#  description = "The map with S3 object data of zip archive deployed (if deployment was from S3)"
#  value       = module.lambda_function_from_package.s3_object
#}
#
