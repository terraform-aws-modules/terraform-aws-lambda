module "wrapper" {
  source = "../../modules/alias"

  for_each = var.items

  allowed_triggers                          = try(each.value.allowed_triggers, var.defaults.allowed_triggers, {})
  create                                    = try(each.value.create, var.defaults.create, true)
  create_async_event_config                 = try(each.value.create_async_event_config, var.defaults.create_async_event_config, false)
  create_qualified_alias_allowed_triggers   = try(each.value.create_qualified_alias_allowed_triggers, var.defaults.create_qualified_alias_allowed_triggers, true)
  create_qualified_alias_async_event_config = try(each.value.create_qualified_alias_async_event_config, var.defaults.create_qualified_alias_async_event_config, true)
  create_version_allowed_triggers           = try(each.value.create_version_allowed_triggers, var.defaults.create_version_allowed_triggers, true)
  create_version_async_event_config         = try(each.value.create_version_async_event_config, var.defaults.create_version_async_event_config, true)
  description                               = try(each.value.description, var.defaults.description, "")
  destination_on_failure                    = try(each.value.destination_on_failure, var.defaults.destination_on_failure, null)
  destination_on_success                    = try(each.value.destination_on_success, var.defaults.destination_on_success, null)
  event_source_mapping                      = try(each.value.event_source_mapping, var.defaults.event_source_mapping, {})
  function_name                             = try(each.value.function_name, var.defaults.function_name, "")
  function_version                          = try(each.value.function_version, var.defaults.function_version, "")
  maximum_event_age_in_seconds              = try(each.value.maximum_event_age_in_seconds, var.defaults.maximum_event_age_in_seconds, null)
  maximum_retry_attempts                    = try(each.value.maximum_retry_attempts, var.defaults.maximum_retry_attempts, null)
  name                                      = try(each.value.name, var.defaults.name, "")
  refresh_alias                             = try(each.value.refresh_alias, var.defaults.refresh_alias, true)
  routing_additional_version_weights        = try(each.value.routing_additional_version_weights, var.defaults.routing_additional_version_weights, {})
  use_existing_alias                        = try(each.value.use_existing_alias, var.defaults.use_existing_alias, false)
}
