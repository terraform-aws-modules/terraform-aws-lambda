locals {
  # Use a generated filename to determine when the source code has changed.
  # filename - to get package from local
  filename    = var.local_existing_package != null ? var.local_existing_package : (var.store_on_s3 ? null : element(concat(data.external.archive_prepare.*.result.filename, [null]), 0))
  was_missing = var.local_existing_package != null ? ! fileexists(var.local_existing_package) : element(concat(data.external.archive_prepare.*.result.was_missing, [false]), 0)

  # s3_* - to get package from S3
  s3_bucket         = var.s3_existing_package != null ? lookup(var.s3_existing_package, "bucket", null) : (var.store_on_s3 ? var.s3_bucket : null)
  s3_key            = var.s3_existing_package != null ? lookup(var.s3_existing_package, "key", null) : (var.store_on_s3 ? element(concat(data.external.archive_prepare.*.result.filename, [null]), 0) : null)
  s3_object_version = var.s3_existing_package != null ? lookup(var.s3_existing_package, "version_id", null) : (var.store_on_s3 ? element(concat(aws_s3_bucket_object.lambda_package.*.version_id, [null]), 0) : null)

}

resource "aws_lambda_function" "this" {
  count = var.create && var.create_function && ! var.create_layer ? 1 : 0

  function_name                  = var.function_name
  description                    = var.description
  role                           = var.create_role ? aws_iam_role.lambda[0].arn : var.lambda_role
  handler                        = var.handler
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = var.runtime
  layers                         = var.layers
  timeout                        = var.lambda_at_edge ? min(var.timeout, 5) : var.timeout
  publish                        = var.lambda_at_edge ? true : var.publish
  kms_key_arn                    = var.kms_key_arn

  filename         = local.filename
  source_code_hash = (local.filename == null ? false : fileexists(local.filename)) && ! local.was_missing ? filebase64sha256(local.filename) : null

  s3_bucket         = local.s3_bucket
  s3_key            = local.s3_key
  s3_object_version = local.s3_object_version

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_target_arn == null ? [] : [true]
    content {
      target_arn = var.dead_letter_target_arn
    }
  }

  dynamic "tracing_config" {
    for_each = var.tracing_mode == null ? [] : [true]
    content {
      mode = var.tracing_mode
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_subnet_ids != null && var.vpc_security_group_ids != null ? [true] : []
    content {
      security_group_ids = var.vpc_security_group_ids
      subnet_ids         = var.vpc_subnet_ids
    }
  }

  dynamic "file_system_config" {
    for_each = var.file_system_arn != null && var.file_system_local_mount_path != null ? [true] : []
    content {
      local_mount_path = var.file_system_local_mount_path
      arn              = var.file_system_arn
    }
  }

  tags = var.tags

  depends_on = [null_resource.archive, aws_s3_bucket_object.lambda_package]
}

resource "aws_lambda_layer_version" "this" {
  count = var.create && var.create_layer ? 1 : 0

  layer_name   = var.layer_name
  description  = var.description
  license_info = var.license_info

  compatible_runtimes = length(var.compatible_runtimes) > 0 ? var.compatible_runtimes : [var.runtime]

  filename         = local.filename
  source_code_hash = (local.filename == null ? false : fileexists(local.filename)) && ! local.was_missing ? filebase64sha256(local.filename) : null

  s3_bucket         = local.s3_bucket
  s3_key            = local.s3_key
  s3_object_version = local.s3_object_version

  depends_on = [null_resource.archive, aws_s3_bucket_object.lambda_package]
}

resource "aws_s3_bucket_object" "lambda_package" {
  count = var.create && var.store_on_s3 && var.create_package ? 1 : 0

  bucket        = var.s3_bucket
  key           = data.external.archive_prepare[0].result.filename
  source        = data.external.archive_prepare[0].result.filename
  etag          = fileexists(data.external.archive_prepare[0].result.filename) ? filemd5(data.external.archive_prepare[0].result.filename) : null
  storage_class = var.s3_object_storage_class

  tags = merge(var.tags, var.s3_object_tags)

  depends_on = [null_resource.archive]
}

data "aws_cloudwatch_log_group" "lambda" {
  count = var.create && var.create_function && ! var.create_layer && var.use_existing_cloudwatch_log_group ? 1 : 0

  name = "/aws/lambda/${var.lambda_at_edge ? "us-east-1." : ""}${var.function_name}"
}

resource "aws_cloudwatch_log_group" "lambda" {
  count = var.create && var.create_function && ! var.create_layer && ! var.use_existing_cloudwatch_log_group ? 1 : 0

  name              = "/aws/lambda/${var.lambda_at_edge ? "us-east-1." : ""}${var.function_name}"
  retention_in_days = var.cloudwatch_logs_retention_in_days
  kms_key_id        = var.cloudwatch_logs_kms_key_id

  tags = merge(var.tags, var.cloudwatch_logs_tags)
}

resource "aws_lambda_provisioned_concurrency_config" "current_version" {
  count = var.create && var.create_function && ! var.create_layer && var.provisioned_concurrent_executions > -1 ? 1 : 0

  function_name = aws_lambda_function.this[0].function_name
  qualifier     = aws_lambda_function.this[0].version

  provisioned_concurrent_executions = var.provisioned_concurrent_executions
}

locals {
  qualifiers = zipmap(["current_version", "unqualified_alias"], [var.create_current_version_async_event_config ? true : null, var.create_unqualified_alias_async_event_config ? true : null])
}

resource "aws_lambda_function_event_invoke_config" "this" {
  for_each = var.create && var.create_function && ! var.create_layer && var.create_async_event_config ? local.qualifiers : {}

  function_name = aws_lambda_function.this[0].function_name
  qualifier     = each.key == "current_version" ? aws_lambda_function.this[0].version : null

  maximum_event_age_in_seconds = var.maximum_event_age_in_seconds
  maximum_retry_attempts       = var.maximum_retry_attempts

  dynamic "destination_config" {
    for_each = var.destination_on_failure != null || var.destination_on_success != null ? [true] : []
    content {
      dynamic "on_failure" {
        for_each = var.destination_on_failure != null ? [true] : []
        content {
          destination = var.destination_on_failure
        }
      }

      dynamic "on_success" {
        for_each = var.destination_on_success != null ? [true] : []
        content {
          destination = var.destination_on_success
        }
      }
    }
  }
}

resource "aws_lambda_permission" "current_version_triggers" {
  for_each = var.create && var.create_function && ! var.create_layer && var.create_current_version_allowed_triggers ? var.allowed_triggers : {}

  function_name = aws_lambda_function.this[0].function_name
  qualifier     = aws_lambda_function.this[0].version

  statement_id       = lookup(each.value, "statement_id", each.key)
  action             = lookup(each.value, "action", "lambda:InvokeFunction")
  principal          = lookup(each.value, "principal", format("%s.amazonaws.com", lookup(each.value, "service", "")))
  source_arn         = lookup(each.value, "source_arn", lookup(each.value, "service", null) == "apigateway" ? "${lookup(each.value, "arn", "")}/*/*/*" : null)
  source_account     = lookup(each.value, "source_account", null)
  event_source_token = lookup(each.value, "event_source_token", null)
}

// Error: Error adding new Lambda Permission for destined-tetra-lambda: InvalidParameterValueException: We currently do not support adding policies for $LATEST.
resource "aws_lambda_permission" "unqualified_alias_triggers" {
  for_each = var.create && var.create_function && ! var.create_layer && var.create_unqualified_alias_allowed_triggers ? var.allowed_triggers : {}

  function_name = aws_lambda_function.this[0].function_name

  statement_id       = lookup(each.value, "statement_id", each.key)
  action             = lookup(each.value, "action", "lambda:InvokeFunction")
  principal          = lookup(each.value, "principal", format("%s.amazonaws.com", lookup(each.value, "service", "")))
  source_arn         = lookup(each.value, "source_arn", lookup(each.value, "service", null) == "apigateway" ? "${lookup(each.value, "arn", "")}/*/*/*" : null)
  source_account     = lookup(each.value, "source_account", null)
  event_source_token = lookup(each.value, "event_source_token", null)
}
