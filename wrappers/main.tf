module "wrapper" {
  source = "../"

  for_each = var.items

  allowed_triggers                             = try(each.value.allowed_triggers, var.defaults.allowed_triggers, {})
  architectures                                = try(each.value.architectures, var.defaults.architectures, null)
  artifacts_dir                                = try(each.value.artifacts_dir, var.defaults.artifacts_dir, "builds")
  assume_role_policy_statements                = try(each.value.assume_role_policy_statements, var.defaults.assume_role_policy_statements, {})
  attach_async_event_policy                    = try(each.value.attach_async_event_policy, var.defaults.attach_async_event_policy, false)
  attach_cloudwatch_logs_policy                = try(each.value.attach_cloudwatch_logs_policy, var.defaults.attach_cloudwatch_logs_policy, true)
  attach_create_log_group_permission           = try(each.value.attach_create_log_group_permission, var.defaults.attach_create_log_group_permission, true)
  attach_dead_letter_policy                    = try(each.value.attach_dead_letter_policy, var.defaults.attach_dead_letter_policy, false)
  attach_network_policy                        = try(each.value.attach_network_policy, var.defaults.attach_network_policy, false)
  attach_policies                              = try(each.value.attach_policies, var.defaults.attach_policies, false)
  attach_policy                                = try(each.value.attach_policy, var.defaults.attach_policy, false)
  attach_policy_json                           = try(each.value.attach_policy_json, var.defaults.attach_policy_json, false)
  attach_policy_jsons                          = try(each.value.attach_policy_jsons, var.defaults.attach_policy_jsons, false)
  attach_policy_statements                     = try(each.value.attach_policy_statements, var.defaults.attach_policy_statements, false)
  attach_tracing_policy                        = try(each.value.attach_tracing_policy, var.defaults.attach_tracing_policy, false)
  authorization_type                           = try(each.value.authorization_type, var.defaults.authorization_type, "NONE")
  build_in_docker                              = try(each.value.build_in_docker, var.defaults.build_in_docker, false)
  cloudwatch_logs_kms_key_id                   = try(each.value.cloudwatch_logs_kms_key_id, var.defaults.cloudwatch_logs_kms_key_id, null)
  cloudwatch_logs_log_group_class              = try(each.value.cloudwatch_logs_log_group_class, var.defaults.cloudwatch_logs_log_group_class, null)
  cloudwatch_logs_retention_in_days            = try(each.value.cloudwatch_logs_retention_in_days, var.defaults.cloudwatch_logs_retention_in_days, null)
  cloudwatch_logs_skip_destroy                 = try(each.value.cloudwatch_logs_skip_destroy, var.defaults.cloudwatch_logs_skip_destroy, false)
  cloudwatch_logs_tags                         = try(each.value.cloudwatch_logs_tags, var.defaults.cloudwatch_logs_tags, {})
  code_signing_config_arn                      = try(each.value.code_signing_config_arn, var.defaults.code_signing_config_arn, null)
  compatible_architectures                     = try(each.value.compatible_architectures, var.defaults.compatible_architectures, null)
  compatible_runtimes                          = try(each.value.compatible_runtimes, var.defaults.compatible_runtimes, [])
  cors                                         = try(each.value.cors, var.defaults.cors, {})
  create                                       = try(each.value.create, var.defaults.create, true)
  create_async_event_config                    = try(each.value.create_async_event_config, var.defaults.create_async_event_config, false)
  create_current_version_allowed_triggers      = try(each.value.create_current_version_allowed_triggers, var.defaults.create_current_version_allowed_triggers, true)
  create_current_version_async_event_config    = try(each.value.create_current_version_async_event_config, var.defaults.create_current_version_async_event_config, true)
  create_function                              = try(each.value.create_function, var.defaults.create_function, true)
  create_lambda_function_url                   = try(each.value.create_lambda_function_url, var.defaults.create_lambda_function_url, false)
  create_layer                                 = try(each.value.create_layer, var.defaults.create_layer, false)
  create_package                               = try(each.value.create_package, var.defaults.create_package, true)
  create_role                                  = try(each.value.create_role, var.defaults.create_role, true)
  create_sam_metadata                          = try(each.value.create_sam_metadata, var.defaults.create_sam_metadata, false)
  create_unqualified_alias_allowed_triggers    = try(each.value.create_unqualified_alias_allowed_triggers, var.defaults.create_unqualified_alias_allowed_triggers, true)
  create_unqualified_alias_async_event_config  = try(each.value.create_unqualified_alias_async_event_config, var.defaults.create_unqualified_alias_async_event_config, true)
  create_unqualified_alias_lambda_function_url = try(each.value.create_unqualified_alias_lambda_function_url, var.defaults.create_unqualified_alias_lambda_function_url, true)
  dead_letter_target_arn                       = try(each.value.dead_letter_target_arn, var.defaults.dead_letter_target_arn, null)
  description                                  = try(each.value.description, var.defaults.description, "")
  destination_on_failure                       = try(each.value.destination_on_failure, var.defaults.destination_on_failure, null)
  destination_on_success                       = try(each.value.destination_on_success, var.defaults.destination_on_success, null)
  docker_additional_options                    = try(each.value.docker_additional_options, var.defaults.docker_additional_options, [])
  docker_build_root                            = try(each.value.docker_build_root, var.defaults.docker_build_root, "")
  docker_entrypoint                            = try(each.value.docker_entrypoint, var.defaults.docker_entrypoint, null)
  docker_file                                  = try(each.value.docker_file, var.defaults.docker_file, "")
  docker_image                                 = try(each.value.docker_image, var.defaults.docker_image, "")
  docker_pip_cache                             = try(each.value.docker_pip_cache, var.defaults.docker_pip_cache, null)
  docker_with_ssh_agent                        = try(each.value.docker_with_ssh_agent, var.defaults.docker_with_ssh_agent, false)
  environment_variables                        = try(each.value.environment_variables, var.defaults.environment_variables, {})
  ephemeral_storage_size                       = try(each.value.ephemeral_storage_size, var.defaults.ephemeral_storage_size, 512)
  event_source_mapping                         = try(each.value.event_source_mapping, var.defaults.event_source_mapping, {})
  file_system_arn                              = try(each.value.file_system_arn, var.defaults.file_system_arn, null)
  file_system_local_mount_path                 = try(each.value.file_system_local_mount_path, var.defaults.file_system_local_mount_path, null)
  function_name                                = try(each.value.function_name, var.defaults.function_name, "")
  function_tags                                = try(each.value.function_tags, var.defaults.function_tags, {})
  handler                                      = try(each.value.handler, var.defaults.handler, "")
  hash_extra                                   = try(each.value.hash_extra, var.defaults.hash_extra, "")
  ignore_source_code_hash                      = try(each.value.ignore_source_code_hash, var.defaults.ignore_source_code_hash, false)
  image_config_command                         = try(each.value.image_config_command, var.defaults.image_config_command, [])
  image_config_entry_point                     = try(each.value.image_config_entry_point, var.defaults.image_config_entry_point, [])
  image_config_working_directory               = try(each.value.image_config_working_directory, var.defaults.image_config_working_directory, null)
  image_uri                                    = try(each.value.image_uri, var.defaults.image_uri, null)
  invoke_mode                                  = try(each.value.invoke_mode, var.defaults.invoke_mode, null)
  kms_key_arn                                  = try(each.value.kms_key_arn, var.defaults.kms_key_arn, null)
  lambda_at_edge                               = try(each.value.lambda_at_edge, var.defaults.lambda_at_edge, false)
  lambda_at_edge_logs_all_regions              = try(each.value.lambda_at_edge_logs_all_regions, var.defaults.lambda_at_edge_logs_all_regions, true)
  lambda_role                                  = try(each.value.lambda_role, var.defaults.lambda_role, "")
  layer_name                                   = try(each.value.layer_name, var.defaults.layer_name, "")
  layer_skip_destroy                           = try(each.value.layer_skip_destroy, var.defaults.layer_skip_destroy, false)
  layers                                       = try(each.value.layers, var.defaults.layers, null)
  license_info                                 = try(each.value.license_info, var.defaults.license_info, "")
  local_existing_package                       = try(each.value.local_existing_package, var.defaults.local_existing_package, null)
  logging_application_log_level                = try(each.value.logging_application_log_level, var.defaults.logging_application_log_level, "INFO")
  logging_log_format                           = try(each.value.logging_log_format, var.defaults.logging_log_format, "Text")
  logging_log_group                            = try(each.value.logging_log_group, var.defaults.logging_log_group, null)
  logging_system_log_level                     = try(each.value.logging_system_log_level, var.defaults.logging_system_log_level, "INFO")
  maximum_event_age_in_seconds                 = try(each.value.maximum_event_age_in_seconds, var.defaults.maximum_event_age_in_seconds, null)
  maximum_retry_attempts                       = try(each.value.maximum_retry_attempts, var.defaults.maximum_retry_attempts, null)
  memory_size                                  = try(each.value.memory_size, var.defaults.memory_size, 128)
  number_of_policies                           = try(each.value.number_of_policies, var.defaults.number_of_policies, 0)
  number_of_policy_jsons                       = try(each.value.number_of_policy_jsons, var.defaults.number_of_policy_jsons, 0)
  package_type                                 = try(each.value.package_type, var.defaults.package_type, "Zip")
  policies                                     = try(each.value.policies, var.defaults.policies, [])
  policy                                       = try(each.value.policy, var.defaults.policy, null)
  policy_json                                  = try(each.value.policy_json, var.defaults.policy_json, null)
  policy_jsons                                 = try(each.value.policy_jsons, var.defaults.policy_jsons, [])
  policy_name                                  = try(each.value.policy_name, var.defaults.policy_name, null)
  policy_statements                            = try(each.value.policy_statements, var.defaults.policy_statements, {})
  provisioned_concurrent_executions            = try(each.value.provisioned_concurrent_executions, var.defaults.provisioned_concurrent_executions, -1)
  publish                                      = try(each.value.publish, var.defaults.publish, false)
  putin_khuylo                                 = try(each.value.putin_khuylo, var.defaults.putin_khuylo, true)
  recreate_missing_package                     = try(each.value.recreate_missing_package, var.defaults.recreate_missing_package, true)
  replace_security_groups_on_destroy           = try(each.value.replace_security_groups_on_destroy, var.defaults.replace_security_groups_on_destroy, null)
  replacement_security_group_ids               = try(each.value.replacement_security_group_ids, var.defaults.replacement_security_group_ids, null)
  reserved_concurrent_executions               = try(each.value.reserved_concurrent_executions, var.defaults.reserved_concurrent_executions, -1)
  role_description                             = try(each.value.role_description, var.defaults.role_description, null)
  role_force_detach_policies                   = try(each.value.role_force_detach_policies, var.defaults.role_force_detach_policies, true)
  role_maximum_session_duration                = try(each.value.role_maximum_session_duration, var.defaults.role_maximum_session_duration, 3600)
  role_name                                    = try(each.value.role_name, var.defaults.role_name, null)
  role_path                                    = try(each.value.role_path, var.defaults.role_path, null)
  role_permissions_boundary                    = try(each.value.role_permissions_boundary, var.defaults.role_permissions_boundary, null)
  role_tags                                    = try(each.value.role_tags, var.defaults.role_tags, {})
  runtime                                      = try(each.value.runtime, var.defaults.runtime, "")
  s3_acl                                       = try(each.value.s3_acl, var.defaults.s3_acl, "private")
  s3_bucket                                    = try(each.value.s3_bucket, var.defaults.s3_bucket, null)
  s3_existing_package                          = try(each.value.s3_existing_package, var.defaults.s3_existing_package, null)
  s3_kms_key_id                                = try(each.value.s3_kms_key_id, var.defaults.s3_kms_key_id, null)
  s3_object_override_default_tags              = try(each.value.s3_object_override_default_tags, var.defaults.s3_object_override_default_tags, false)
  s3_object_storage_class                      = try(each.value.s3_object_storage_class, var.defaults.s3_object_storage_class, "ONEZONE_IA")
  s3_object_tags                               = try(each.value.s3_object_tags, var.defaults.s3_object_tags, {})
  s3_object_tags_only                          = try(each.value.s3_object_tags_only, var.defaults.s3_object_tags_only, false)
  s3_prefix                                    = try(each.value.s3_prefix, var.defaults.s3_prefix, null)
  s3_server_side_encryption                    = try(each.value.s3_server_side_encryption, var.defaults.s3_server_side_encryption, null)
  skip_destroy                                 = try(each.value.skip_destroy, var.defaults.skip_destroy, null)
  snap_start                                   = try(each.value.snap_start, var.defaults.snap_start, false)
  source_path                                  = try(each.value.source_path, var.defaults.source_path, null)
  store_on_s3                                  = try(each.value.store_on_s3, var.defaults.store_on_s3, false)
  tags                                         = try(each.value.tags, var.defaults.tags, {})
  timeout                                      = try(each.value.timeout, var.defaults.timeout, 3)
  timeouts                                     = try(each.value.timeouts, var.defaults.timeouts, {})
  tracing_mode                                 = try(each.value.tracing_mode, var.defaults.tracing_mode, null)
  trigger_on_package_timestamp                 = try(each.value.trigger_on_package_timestamp, var.defaults.trigger_on_package_timestamp, true)
  trusted_entities                             = try(each.value.trusted_entities, var.defaults.trusted_entities, [])
  use_existing_cloudwatch_log_group            = try(each.value.use_existing_cloudwatch_log_group, var.defaults.use_existing_cloudwatch_log_group, false)
  vpc_security_group_ids                       = try(each.value.vpc_security_group_ids, var.defaults.vpc_security_group_ids, null)
  vpc_subnet_ids                               = try(each.value.vpc_subnet_ids, var.defaults.vpc_subnet_ids, null)
}
