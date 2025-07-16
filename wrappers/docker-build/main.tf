module "wrapper" {
  source = "../../modules/docker-build"

  for_each = var.items

  build_args                = try(each.value.build_args, var.defaults.build_args, {})
  build_target              = try(each.value.build_target, var.defaults.build_target, null)
  builder                   = try(each.value.builder, var.defaults.builder, null)
  cache_from                = try(each.value.cache_from, var.defaults.cache_from, [])
  create_ecr_repo           = try(each.value.create_ecr_repo, var.defaults.create_ecr_repo, false)
  create_sam_metadata       = try(each.value.create_sam_metadata, var.defaults.create_sam_metadata, false)
  docker_file_path          = try(each.value.docker_file_path, var.defaults.docker_file_path, "Dockerfile")
  ecr_address               = try(each.value.ecr_address, var.defaults.ecr_address, null)
  ecr_force_delete          = try(each.value.ecr_force_delete, var.defaults.ecr_force_delete, true)
  ecr_repo                  = try(each.value.ecr_repo, var.defaults.ecr_repo, null)
  ecr_repo_lifecycle_policy = try(each.value.ecr_repo_lifecycle_policy, var.defaults.ecr_repo_lifecycle_policy, null)
  ecr_repo_tags             = try(each.value.ecr_repo_tags, var.defaults.ecr_repo_tags, {})
  force_remove              = try(each.value.force_remove, var.defaults.force_remove, false)
  image_tag                 = try(each.value.image_tag, var.defaults.image_tag, null)
  image_tag_mutability      = try(each.value.image_tag_mutability, var.defaults.image_tag_mutability, "MUTABLE")
  keep_locally              = try(each.value.keep_locally, var.defaults.keep_locally, false)
  keep_remotely             = try(each.value.keep_remotely, var.defaults.keep_remotely, false)
  platform                  = try(each.value.platform, var.defaults.platform, null)
  scan_on_push              = try(each.value.scan_on_push, var.defaults.scan_on_push, false)
  source_path               = try(each.value.source_path, var.defaults.source_path, null)
  triggers                  = try(each.value.triggers, var.defaults.triggers, {})
  use_image_tag             = try(each.value.use_image_tag, var.defaults.use_image_tag, true)
}
