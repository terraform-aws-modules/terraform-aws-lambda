resource "aws_cloudwatch_log_group" "lambda" {
  count = local.create_role && var.attach_cloudwatch_logs_policy && ! var.lambda_at_edge ? 1 : 0
  name = "/aws/lambda/${var.function_name}"
  retention_in_days = var.cloudwatch_logs_retention
}

resource "aws_cloudwatch_log_group" "lambda-edge" {
  count = local.create_role && var.attach_cloudwatch_logs_policy && var.lambda_at_edge ? 1 : 0
  name = "/aws/lambda/us-east-1.${var.function_name}"
  retention_in_days = var.cloudwatch_logs_retention
}
