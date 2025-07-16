data "aws_region" "current" {}

data "aws_caller_identity" "this" {}

locals {
  ecr_address    = coalesce(var.ecr_address, format("%v.dkr.ecr.%v.amazonaws.com", data.aws_caller_identity.this.account_id, data.aws_region.current.region))
  ecr_repo       = var.create_ecr_repo ? aws_ecr_repository.this[0].id : var.ecr_repo
  image_tag      = var.use_image_tag ? coalesce(var.image_tag, formatdate("YYYYMMDDhhmmss", timestamp())) : null
  ecr_image_name = var.use_image_tag ? format("%v/%v:%v", local.ecr_address, local.ecr_repo, local.image_tag) : format("%v/%v", local.ecr_address, local.ecr_repo)
}

resource "docker_image" "this" {
  name = local.ecr_image_name

  build {
    context    = var.source_path
    dockerfile = var.docker_file_path
    build_args = var.build_args
    builder    = var.builder
    target     = var.build_target
    platform   = var.platform
    cache_from = var.cache_from
  }

  force_remove = var.force_remove
  keep_locally = var.keep_locally
  triggers     = var.triggers
}

resource "docker_registry_image" "this" {
  name = docker_image.this.name

  keep_remotely = var.keep_remotely

  triggers = length(var.triggers) == 0 ? { image_id = docker_image.this.image_id } : var.triggers
}

resource "aws_ecr_repository" "this" {
  count = var.create_ecr_repo ? 1 : 0

  force_delete         = var.ecr_force_delete
  name                 = var.ecr_repo
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = var.ecr_repo_tags
}

resource "aws_ecr_lifecycle_policy" "this" {
  count = var.ecr_repo_lifecycle_policy != null ? 1 : 0

  policy     = var.ecr_repo_lifecycle_policy
  repository = local.ecr_repo
}

# This resource contains the extra information required by SAM CLI to provide the testing capabilities
# to the TF application. This resource will maintain the metadata information about the image type lambda
# functions. It will contain the information required to build the docker image locally.
resource "null_resource" "sam_metadata_docker_registry_image" {
  count = var.create_sam_metadata ? 1 : 0

  triggers = {
    resource_type     = "IMAGE_LAMBDA_FUNCTION"
    docker_context    = var.source_path
    docker_file       = var.docker_file_path
    docker_build_args = jsonencode(var.build_args)
    docker_tag        = var.image_tag
    built_image_uri   = docker_registry_image.this.name
  }

  depends_on = [docker_registry_image.this]
}
