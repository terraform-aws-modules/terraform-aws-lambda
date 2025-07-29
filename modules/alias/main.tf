locals {
  alias_arn  = try(data.aws_lambda_alias.existing[0].arn, aws_lambda_alias.no_refresh[0].arn, aws_lambda_alias.with_refresh[0].arn, "")
  version    = try(data.aws_lambda_alias.existing[0].function_version, aws_lambda_alias.with_refresh[0].function_version, aws_lambda_alias.no_refresh[0].function_version, "")
  qualifiers = zipmap(["version", "qualified_alias"], [var.create_version_async_event_config ? true : null, var.create_qualified_alias_async_event_config ? true : null])
}

data "aws_lambda_alias" "existing" {
  count = var.create && var.use_existing_alias ? 1 : 0

  function_name = var.function_name
  name          = var.name
}

resource "aws_lambda_alias" "no_refresh" {
  count = var.create && !var.use_existing_alias && !var.refresh_alias ? 1 : 0

  name        = var.name
  description = var.description

  function_name    = var.function_name
  function_version = var.function_version != "" ? var.function_version : "$LATEST"

  # $LATEST is not supported for an alias pointing to more than 1 version
  dynamic "routing_config" {
    for_each = length(keys(var.routing_additional_version_weights)) == 0 ? [] : [true]
    content {
      additional_version_weights = var.routing_additional_version_weights
    }
  }

  lifecycle {
    ignore_changes = [function_version]
  }
}

resource "aws_lambda_alias" "with_refresh" {
  count = var.create && !var.use_existing_alias && var.refresh_alias ? 1 : 0

  name        = var.name
  description = var.description

  function_name    = var.function_name
  function_version = var.function_version != "" ? var.function_version : "$LATEST"

  # $LATEST is not supported for an alias pointing to more than 1 version
  dynamic "routing_config" {
    for_each = length(keys(var.routing_additional_version_weights)) == 0 ? [] : [true]
    content {
      additional_version_weights = var.routing_additional_version_weights
    }
  }
}

resource "aws_lambda_function_event_invoke_config" "this" {
  for_each = var.create && var.create_async_event_config ? local.qualifiers : {}

  function_name = var.function_name
  qualifier     = each.key == "version" ? local.version : var.name

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

resource "aws_lambda_permission" "version_triggers" {
  for_each = var.create && var.create_version_allowed_triggers ? var.allowed_triggers : {}

  function_name = var.function_name

  # Error: Error adding new Lambda Permission for ... InvalidParameterValueException: We currently do not support adding policies for $LATEST.
  qualifier = local.version != "$LATEST" ? local.version : null

  statement_id       = try(each.value.statement_id, each.key)
  action             = try(each.value.action, "lambda:InvokeFunction")
  principal          = try(each.value.principal, format("%s.amazonaws.com", try(each.value.service, "")))
  principal_org_id   = try(each.value.principal_org_id, null)
  source_arn         = try(each.value.source_arn, null)
  source_account     = try(each.value.source_account, null)
  event_source_token = try(each.value.event_source_token, null)
}

resource "aws_lambda_permission" "qualified_alias_triggers" {
  for_each = var.create && var.create_qualified_alias_allowed_triggers ? var.allowed_triggers : {}

  function_name = var.function_name
  qualifier     = var.name

  statement_id       = try(each.value.statement_id, each.key)
  action             = try(each.value.action, "lambda:InvokeFunction")
  principal          = try(each.value.principal, format("%s.amazonaws.com", try(each.value.service, "")))
  principal_org_id   = try(each.value.principal_org_id, null)
  source_arn         = try(each.value.source_arn, null)
  source_account     = try(each.value.source_account, null)
  event_source_token = try(each.value.event_source_token, null)
}

resource "aws_lambda_event_source_mapping" "this" {
  for_each = { for k, v in var.event_source_mapping : k => v if var.create }

  function_name = local.alias_arn

  event_source_arn = try(each.value.event_source_arn, null)

  batch_size                         = try(each.value.batch_size, null)
  maximum_batching_window_in_seconds = try(each.value.maximum_batching_window_in_seconds, null)
  enabled                            = try(each.value.enabled, null)
  starting_position                  = try(each.value.starting_position, null)
  starting_position_timestamp        = try(each.value.starting_position_timestamp, null)
  parallelization_factor             = try(each.value.parallelization_factor, null)
  maximum_retry_attempts             = try(each.value.maximum_retry_attempts, null)
  maximum_record_age_in_seconds      = try(each.value.maximum_record_age_in_seconds, null)
  bisect_batch_on_function_error     = try(each.value.bisect_batch_on_function_error, null)
  topics                             = try(each.value.topics, null)
  queues                             = try(each.value.queues, null)
  function_response_types            = try(each.value.function_response_types, null)

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
      consumer_group_id = try(self_managed_kafka_event_source_config.value.consumer_group_id, null)
    }
  }

  dynamic "amazon_managed_kafka_event_source_config" {
    for_each = try(each.value.amazon_managed_kafka_event_source_config, [])
    content {
      consumer_group_id = try(amazon_managed_kafka_event_source_config.value.consumer_group_id, null)
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
}
