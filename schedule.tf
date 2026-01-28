locals {
  schedule_count = var.schedule_expression != "" && local.create && var.create_function && !var.create_layer ? 1 : 0
}

resource "aws_scheduler_schedule" "this" {
  count = local.schedule_count

  name                = var.function_name
  schedule_expression = var.schedule_expression
  flexible_time_window {
    mode = "OFF"
  }
  target {
    arn      = aws_lambda_function.this[0].arn
    role_arn = aws_iam_role.invoke_lambda[0].arn
    input = jsonencode({
      action = "scheduled-invoke"
    })
    retry_policy {
      maximum_retry_attempts = 0
    }
  }
}

variable "schedule_expression" {
  description = "The schedule expression that defines when the schedule will run."
  type        = string
  default     = ""
}

resource "aws_iam_role" "invoke_lambda" {
  count = local.schedule_count

  name = "fetch-lambda-scheduler-invoke-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "invoke_lambda" {
  count = local.schedule_count
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:InvokeFunction"
        ]
        Effect   = "Allow"
        Resource = aws_lambda_function.this[0].arn
      }
    ]
  })
  role = aws_iam_role.invoke_lambda[0].name
}

resource "aws_lambda_permission" "scheduler_invoke" {
  count = local.schedule_count

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this[0].function_name
  principal     = aws_iam_role.invoke_lambda[0].arn
}
