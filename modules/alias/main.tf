locals {
  version    = element(concat(data.aws_lambda_alias.existing.*.function_version, aws_lambda_alias.with_refresh.*.function_version, aws_lambda_alias.no_refresh.*.function_version, [""]), 0)
  qualifiers = zipmap(["version", "qualified_alias"], [var.create_version_async_event_config ? true : null, var.create_qualified_alias_async_event_config ? true : null])
}

data "aws_lambda_alias" "existing" {
  count = var.create && var.use_existing_alias ? 1 : 0

  function_name = var.function_name
  name          = var.name
}

resource "aws_lambda_alias" "no_refresh" {
  count = var.create && ! var.use_existing_alias && ! var.refresh_alias ? 1 : 0

  name        = var.name
  description = var.description

  function_name    = var.function_name
  function_version = var.function_version != "" ? var.function_version : "$LATEST"

  // $LATEST is not supported for an alias pointing to more than 1 version
  dynamic "routing_config" {
    for_each = length(keys(var.routing_additional_version_weights)) == 0 ? [] : [true]
    content {
      additional_version_weights = var.routing_additional_version_weights
    }
  }
}

resource "aws_lambda_alias" "with_refresh" {
  count = var.create && ! var.use_existing_alias && var.refresh_alias ? 1 : 0

  name        = var.name
  description = var.description

  function_name    = var.function_name
  function_version = var.function_version != "" ? var.function_version : "$LATEST"

  // $LATEST is not supported for an alias pointing to more than 1 version
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

  // Error: Error adding new Lambda Permission for ... InvalidParameterValueException: We currently do not support adding policies for $LATEST.
  qualifier = local.version != "$LATEST" ? local.version : null

  statement_id       = lookup(each.value, "statement_id", each.key)
  action             = lookup(each.value, "action", "lambda:InvokeFunction")
  principal          = lookup(each.value, "principal", format("%s.amazonaws.com", lookup(each.value, "service", "")))
  source_arn         = lookup(each.value, "source_arn", lookup(each.value, "service", null) == "apigateway" ? "${lookup(each.value, "arn", "")}/*/*/*" : null)
  source_account     = lookup(each.value, "source_account", null)
  event_source_token = lookup(each.value, "event_source_token", null)
}

resource "aws_lambda_permission" "qualified_alias_triggers" {
  for_each = var.create && var.create_qualified_alias_allowed_triggers ? var.allowed_triggers : {}

  function_name = var.function_name
  qualifier     = var.name

  statement_id       = lookup(each.value, "statement_id", each.key)
  action             = lookup(each.value, "action", "lambda:InvokeFunction")
  principal          = lookup(each.value, "principal", format("%s.amazonaws.com", lookup(each.value, "service", "")))
  source_arn         = lookup(each.value, "source_arn", lookup(each.value, "service", null) == "apigateway" ? "${lookup(each.value, "arn", "")}/*/*/*" : null)
  source_account     = lookup(each.value, "source_account", null)
  event_source_token = lookup(each.value, "event_source_token", null)
}
