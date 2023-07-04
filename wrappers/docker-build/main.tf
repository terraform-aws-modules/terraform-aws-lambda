module "wrapper" {
  source = "../../modules/docker-build"

  for_each = var.items

  create_ecr_repo           = try(each.value.create_ecr_repo, var.defaults.create_ecr_repo, false)
  ecr_address               = try(each.value.ecr_address, var.defaults.ecr_address, null)
  ecr_repo                  = try(each.value.ecr_repo, var.defaults.ecr_repo, null)
  image_tag                 = try(each.value.image_tag, var.defaults.image_tag, null)
  source_path               = try(each.value.source_path, var.defaults.source_path, null)
  docker_file_path          = try(each.value.docker_file_path, var.defaults.docker_file_path, "Dockerfile")
  image_tag_mutability      = try(each.value.image_tag_mutability, var.defaults.image_tag_mutability, "MUTABLE")
  scan_on_push              = try(each.value.scan_on_push, var.defaults.scan_on_push, false)
  ecr_force_delete          = try(each.value.ecr_force_delete, var.defaults.ecr_force_delete, true)
  ecr_repo_tags             = try(each.value.ecr_repo_tags, var.defaults.ecr_repo_tags, {})
  build_args                = try(each.value.build_args, var.defaults.build_args, {})
  ecr_repo_lifecycle_policy = try(each.value.ecr_repo_lifecycle_policy, var.defaults.ecr_repo_lifecycle_policy, null)
  keep_remotely             = try(each.value.keep_remotely, var.defaults.keep_remotely, false)
  platform                  = try(each.value.platform, var.defaults.platform, null)
}
