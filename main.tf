data "aws_partition" "current" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  create = var.create && var.putin_khuylo

  archive_filename        = try(data.external.archive_prepare[0].result.filename, null)
  archive_filename_string = local.archive_filename != null ? local.archive_filename : ""
  archive_was_missing     = try(data.external.archive_prepare[0].result.was_missing, false)

  # Use a generated filename to determine when the source code has changed.
  # filename - to get package from local
  filename    = var.local_existing_package != null ? var.local_existing_package : (var.store_on_s3 ? null : local.archive_filename)
  was_missing = var.local_existing_package != null ? !fileexists(var.local_existing_package) : local.archive_was_missing

  # s3_* - to get package from S3
  s3_bucket         = var.s3_existing_package != null ? try(var.s3_existing_package.bucket, null) : (var.store_on_s3 ? var.s3_bucket : null)
  s3_key            = var.s3_existing_package != null ? try(var.s3_existing_package.key, null) : (var.store_on_s3 ? var.s3_prefix != null ? format("%s%s", var.s3_prefix, replace(local.archive_filename_string, "/^.*//", "")) : replace(local.archive_filename_string, "/^\\.//", "") : null)
  s3_object_version = var.s3_existing_package != null ? try(var.s3_existing_package.version_id, null) : (var.store_on_s3 ? try(aws_s3_object.lambda_package[0].version_id, null) : null)

}

resource "aws_lambda_function" "this" {
  count = local.create && var.create_function && !var.create_layer ? 1 : 0

  region = var.region

  function_name                      = var.function_name
  description                        = var.description
  role                               = var.create_role ? aws_iam_role.lambda[0].arn : var.lambda_role
  handler                            = var.package_type != "Zip" ? null : var.handler
  memory_size                        = var.memory_size
  reserved_concurrent_executions     = var.reserved_concurrent_executions
  runtime                            = var.package_type != "Zip" ? null : var.runtime
  layers                             = var.layers
  timeout                            = var.lambda_at_edge ? min(var.timeout, 30) : var.timeout
  publish                            = (var.lambda_at_edge || var.snap_start) ? true : var.publish
  kms_key_arn                        = var.kms_key_arn
  image_uri                          = var.image_uri
  package_type                       = var.package_type
  architectures                      = var.architectures
  code_signing_config_arn            = var.code_signing_config_arn
  replace_security_groups_on_destroy = var.replace_security_groups_on_destroy
  replacement_security_group_ids     = var.replacement_security_group_ids
  skip_destroy                       = var.skip_destroy

  /* ephemeral_storage is not supported in gov-cloud region, so it should be set to `null` */
  dynamic "ephemeral_storage" {
    for_each = var.ephemeral_storage_size == null ? [] : [true]

    content {
      size = var.ephemeral_storage_size
    }
  }

  filename         = local.filename
  source_code_hash = var.ignore_source_code_hash ? null : (local.filename == null ? false : fileexists(local.filename)) && !local.was_missing ? filebase64sha256(local.filename) : null

  s3_bucket         = local.s3_bucket
  s3_key            = local.s3_key
  s3_object_version = local.s3_object_version

  dynamic "image_config" {
    for_each = length(var.image_config_entry_point) > 0 || length(var.image_config_command) > 0 || var.image_config_working_directory != null ? [true] : []
    content {
      entry_point       = var.image_config_entry_point
      command           = var.image_config_command
      working_directory = var.image_config_working_directory
    }
  }

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
      security_group_ids          = var.vpc_security_group_ids
      subnet_ids                  = var.vpc_subnet_ids
      ipv6_allowed_for_dual_stack = var.ipv6_allowed_for_dual_stack
    }
  }

  dynamic "file_system_config" {
    for_each = var.file_system_arn != null && var.file_system_local_mount_path != null ? [true] : []
    content {
      local_mount_path = var.file_system_local_mount_path
      arn              = var.file_system_arn
    }
  }

  dynamic "snap_start" {
    for_each = var.snap_start ? [true] : []

    content {
      apply_on = "PublishedVersions"
    }
  }

  dynamic "logging_config" {
    # Dont create logging config on gov cloud as it is not avaible.
    # See https://github.com/hashicorp/terraform-provider-aws/issues/34810
    for_each = data.aws_partition.current.partition == "aws" ? [true] : []

    content {
      log_group             = var.logging_log_group
      log_format            = var.logging_log_format
      application_log_level = var.logging_log_format == "Text" ? null : var.logging_application_log_level
      system_log_level      = var.logging_log_format == "Text" ? null : var.logging_system_log_level
    }
  }

  dynamic "timeouts" {
    for_each = length(var.timeouts) > 0 ? [true] : []

    content {
      create = try(var.timeouts.create, null)
      update = try(var.timeouts.update, null)
      delete = try(var.timeouts.delete, null)
    }
  }

  tags = merge(
    var.include_default_tag ? { terraform-aws-modules = "lambda" } : {},
    var.tags,
    var.function_tags
  )

  depends_on = [
    null_resource.archive,
    aws_s3_object.lambda_package,

    # Depending on the log group is necessary to allow Terraform to create the log group before AWS can.
    # When a lambda function is invoked, AWS creates the log group automatically if it doesn't exist yet.
    # Without the dependency, this can result in a race condition if the lambda function is invoked before
    # Terraform can create the log group.
    aws_cloudwatch_log_group.lambda,

    # Before the lambda is created the execution role with all its policies should be ready
    aws_iam_role_policy.additional_inline,
    aws_iam_role_policy.additional_json,
    aws_iam_role_policy.additional_jsons,
    aws_iam_role_policy.async,
    aws_iam_role_policy.dead_letter,
    aws_iam_role_policy.logs,
    aws_iam_role_policy.tracing,
    aws_iam_role_policy.vpc,
    aws_iam_role_policy_attachment.additional_many,
    aws_iam_role_policy_attachment.additional_one,
  ]
}

resource "aws_lambda_layer_version" "this" {
  count = local.create && var.create_layer ? 1 : 0

  region = var.region

  layer_name   = var.layer_name
  description  = var.description
  license_info = var.license_info

  compatible_runtimes      = length(var.compatible_runtimes) > 0 ? var.compatible_runtimes : (var.runtime == "" ? null : [var.runtime])
  compatible_architectures = var.compatible_architectures
  skip_destroy             = var.layer_skip_destroy

  filename         = local.filename
  source_code_hash = var.ignore_source_code_hash ? null : (local.filename == null ? false : fileexists(local.filename)) && !local.was_missing ? filebase64sha256(local.filename) : null

  s3_bucket         = local.s3_bucket
  s3_key            = local.s3_key
  s3_object_version = local.s3_object_version

  depends_on = [null_resource.archive, aws_s3_object.lambda_package]
}

resource "aws_s3_object" "lambda_package" {
  count = local.create && var.store_on_s3 && var.create_package ? 1 : 0

  region = var.region

  bucket        = var.s3_bucket
  acl           = var.s3_acl
  key           = local.s3_key
  source        = data.external.archive_prepare[0].result.filename
  storage_class = var.s3_object_storage_class

  server_side_encryption = var.s3_server_side_encryption
  kms_key_id             = var.s3_kms_key_id

  tags = var.s3_object_tags_only ? var.s3_object_tags : merge(var.tags, var.s3_object_tags)

  dynamic "override_provider" {
    for_each = var.s3_object_override_default_tags ? [true] : []

    content {
      default_tags {
        tags = {}
      }
    }
  }

  depends_on = [null_resource.archive]
}

data "aws_cloudwatch_log_group" "lambda" {
  count = local.create && var.create_function && !var.create_layer && var.use_existing_cloudwatch_log_group ? 1 : 0

  region = var.region

  name = coalesce(var.logging_log_group, "/aws/lambda/${var.lambda_at_edge ? "us-east-1." : ""}${var.function_name}")
}

resource "aws_cloudwatch_log_group" "lambda" {
  count = local.create && var.create_function && !var.create_layer && !var.use_existing_cloudwatch_log_group ? 1 : 0

  region = var.region

  name              = coalesce(var.logging_log_group, "/aws/lambda/${var.lambda_at_edge ? "us-east-1." : ""}${var.function_name}")
  retention_in_days = var.cloudwatch_logs_retention_in_days
  kms_key_id        = var.cloudwatch_logs_kms_key_id
  skip_destroy      = var.cloudwatch_logs_skip_destroy
  log_group_class   = var.cloudwatch_logs_log_group_class

  tags = merge(var.tags, var.cloudwatch_logs_tags)
}

resource "aws_lambda_provisioned_concurrency_config" "current_version" {
  count = local.create && var.create_function && !var.create_layer && var.provisioned_concurrent_executions > -1 ? 1 : 0

  region = var.region

  function_name = aws_lambda_function.this[0].function_name
  qualifier     = aws_lambda_function.this[0].version

  provisioned_concurrent_executions = var.provisioned_concurrent_executions
}

locals {
  qualifiers = zipmap(["current_version", "unqualified_alias"], [var.create_current_version_async_event_config ? true : null, var.create_unqualified_alias_async_event_config ? true : null])
}

resource "aws_lambda_function_event_invoke_config" "this" {
  for_each = { for k, v in local.qualifiers : k => v if v != null && local.create && var.create_function && !var.create_layer && var.create_async_event_config }

  region = var.region

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
  for_each = { for k, v in var.allowed_triggers : k => v if local.create && var.create_function && !var.create_layer && var.create_current_version_allowed_triggers }

  region = var.region

  function_name = aws_lambda_function.this[0].function_name
  qualifier     = aws_lambda_function.this[0].version

  statement_id_prefix    = try(each.value.statement_id, each.key)
  action                 = try(each.value.action, "lambda:InvokeFunction")
  principal              = try(each.value.principal, format("%s.amazonaws.com", try(each.value.service, "")))
  principal_org_id       = try(each.value.principal_org_id, null)
  source_arn             = try(each.value.source_arn, null)
  source_account         = try(each.value.source_account, null)
  event_source_token     = try(each.value.event_source_token, null)
  function_url_auth_type = try(each.value.function_url_auth_type, null)

  lifecycle {
    create_before_destroy = true
  }
}

# Error: Error adding new Lambda Permission for lambda: InvalidParameterValueException: We currently do not support adding policies for $LATEST.
resource "aws_lambda_permission" "unqualified_alias_triggers" {
  for_each = { for k, v in var.allowed_triggers : k => v if local.create && var.create_function && !var.create_layer && var.create_unqualified_alias_allowed_triggers }

  region = var.region

  function_name = aws_lambda_function.this[0].function_name

  statement_id_prefix    = try(each.value.statement_id, each.key)
  action                 = try(each.value.action, "lambda:InvokeFunction")
  principal              = try(each.value.principal, format("%s.amazonaws.com", try(each.value.service, "")))
  principal_org_id       = try(each.value.principal_org_id, null)
  source_arn             = try(each.value.source_arn, null)
  source_account         = try(each.value.source_account, null)
  event_source_token     = try(each.value.event_source_token, null)
  function_url_auth_type = try(each.value.function_url_auth_type, null)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_event_source_mapping" "this" {
  for_each = { for k, v in var.event_source_mapping : k => v if local.create && var.create_function && !var.create_layer && var.create_unqualified_alias_allowed_triggers }

  region = var.region

  function_name = aws_lambda_function.this[0].arn

  event_source_arn = try(each.value.event_source_arn, null)

  batch_size                         = try(each.value.batch_size, null)
  maximum_batching_window_in_seconds = try(each.value.maximum_batching_window_in_seconds, null)
  enabled                            = try(each.value.enabled, true)
  starting_position                  = try(each.value.starting_position, null)
  starting_position_timestamp        = try(each.value.starting_position_timestamp, null)
  parallelization_factor             = try(each.value.parallelization_factor, null)
  maximum_retry_attempts             = try(each.value.maximum_retry_attempts, null)
  maximum_record_age_in_seconds      = try(each.value.maximum_record_age_in_seconds, null)
  bisect_batch_on_function_error     = try(each.value.bisect_batch_on_function_error, null)
  topics                             = try(each.value.topics, null)
  queues                             = try(each.value.queues, null)
  function_response_types            = try(each.value.function_response_types, null)
  tumbling_window_in_seconds         = try(each.value.tumbling_window_in_seconds, null)

  dynamic "destination_config" {
    for_each = try(each.value.destination_arn_on_failure, null) != null ? [true] : []
    content {
      on_failure {
        destination_arn = each.value["destination_arn_on_failure"]
      }
    }
  }

  dynamic "scaling_config" {
    for_each = try([each.value.scaling_config], [])
    content {
      maximum_concurrency = try(scaling_config.value.maximum_concurrency, null)
    }
  }


  dynamic "self_managed_event_source" {
    for_each = try(each.value.self_managed_event_source, [])
    content {
      endpoints = self_managed_event_source.value.endpoints
    }
  }

  dynamic "self_managed_kafka_event_source_config" {
    for_each = try(each.value.self_managed_kafka_event_source_config, [])
    content {
      consumer_group_id = self_managed_kafka_event_source_config.value.consumer_group_id
    }
  }
  dynamic "amazon_managed_kafka_event_source_config" {
    for_each = try(each.value.amazon_managed_kafka_event_source_config, [])
    content {
      consumer_group_id = amazon_managed_kafka_event_source_config.value.consumer_group_id
    }
  }

  dynamic "source_access_configuration" {
    for_each = try(each.value.source_access_configuration, [])
    content {
      type = source_access_configuration.value["type"]
      uri  = source_access_configuration.value["uri"]
    }
  }

  dynamic "filter_criteria" {
    for_each = try(each.value.filter_criteria, null) != null ? [true] : []

    content {
      dynamic "filter" {
        for_each = try(flatten([each.value.filter_criteria]), [])

        content {
          pattern = try(filter.value.pattern, null)
        }
      }
    }
  }

  dynamic "document_db_event_source_config" {
    for_each = try(each.value.document_db_event_source_config, [])

    content {
      database_name   = document_db_event_source_config.value.database_name
      collection_name = try(document_db_event_source_config.value.collection_name, null)
      full_document   = try(document_db_event_source_config.value.full_document, null)
    }
  }

  dynamic "metrics_config" {
    for_each = try([each.value.metrics_config], [])

    content {
      metrics = metrics_config.value.metrics
    }
  }

  dynamic "provisioned_poller_config" {
    for_each = try([each.value.provisioned_poller_config], [])
    content {
      maximum_pollers = try(provisioned_poller_config.value.maximum_pollers, null)
      minimum_pollers = try(provisioned_poller_config.value.minimum_pollers, null)
    }
  }

  tags = merge(var.tags, try(each.value.tags, {}))
}

resource "aws_lambda_function_url" "this" {
  count = local.create && var.create_function && !var.create_layer && var.create_lambda_function_url ? 1 : 0

  region = var.region

  function_name = aws_lambda_function.this[0].function_name

  # Error: error creating Lambda Function URL: ValidationException
  qualifier          = var.create_unqualified_alias_lambda_function_url ? null : aws_lambda_function.this[0].version
  authorization_type = var.authorization_type
  invoke_mode        = var.invoke_mode

  dynamic "cors" {
    for_each = length(keys(var.cors)) == 0 ? [] : [var.cors]

    content {
      allow_credentials = try(cors.value.allow_credentials, null)
      allow_headers     = try(cors.value.allow_headers, null)
      allow_methods     = try(cors.value.allow_methods, null)
      allow_origins     = try(cors.value.allow_origins, null)
      expose_headers    = try(cors.value.expose_headers, null)
      max_age           = try(cors.value.max_age, null)
    }
  }
}

resource "aws_lambda_function_recursion_config" "this" {
  count = local.create && var.create_function && !var.create_layer && var.recursive_loop == "Allow" ? 1 : 0

  region = var.region

  function_name  = aws_lambda_function.this[0].function_name
  recursive_loop = var.recursive_loop
}

# This resource contains the extra information required by SAM CLI to provide the testing capabilities
# to the TF application. The required data is where SAM CLI can find the Lambda function source code
# and what are the resources that contain the building logic.
resource "null_resource" "sam_metadata_aws_lambda_function" {
  count = local.create && var.create_sam_metadata && var.create_package && var.create_function && !var.create_layer ? 1 : 0

  triggers = {
    # This is a way to let SAM CLI correlates between the Lambda function resource, and this metadata
    # resource
    resource_name = "aws_lambda_function.this[0]"
    resource_type = "ZIP_LAMBDA_FUNCTION"

    # The Lambda function source code.
    original_source_code = jsonencode(var.source_path)

    # a property to let SAM CLI knows where to find the Lambda function source code if the provided
    # value for original_source_code attribute is map.
    source_code_property = "path"

    # A property to let SAM CLI knows where to find the Lambda function built output
    built_output_path = data.external.archive_prepare[0].result.filename
  }

  # SAM CLI can run terraform apply -target metadata resource, and this will apply the building
  # resources as well
  depends_on = [data.external.archive_prepare, null_resource.archive]
}

# This resource contains the extra information required by SAM CLI to provide the testing capabilities
# to the TF application. The required data is where SAM CLI can find the Lambda layer source code
# and what are the resources that contain the building logic.
resource "null_resource" "sam_metadata_aws_lambda_layer_version" {
  count = local.create && var.create_sam_metadata && var.create_package && var.create_layer ? 1 : 0

  triggers = {
    # This is a way to let SAM CLI correlates between the Lambda layer resource, and this metadata
    # resource
    resource_name = "aws_lambda_layer_version.this[0]"
    resource_type = "LAMBDA_LAYER"

    # The Lambda layer source code.
    original_source_code = jsonencode(var.source_path)

    # a property to let SAM CLI knows where to find the Lambda layer source code if the provided
    # value for original_source_code attribute is map.
    source_code_property = "path"

    # A property to let SAM CLI knows where to find the Lambda layer built output
    built_output_path = data.external.archive_prepare[0].result.filename
  }

  # SAM CLI can run terraform apply -target metadata resource, and this will apply the building
  # resources as well
  depends_on = [data.external.archive_prepare, null_resource.archive]
}
