data "aws_region" "current" {}

data "aws_caller_identity" "this" {}

locals {
  ecr_address    = coalesce(var.ecr_address, format("%v.dkr.ecr.%v.amazonaws.com", data.aws_caller_identity.this.account_id, data.aws_region.current.name))
  ecr_repo       = var.create_ecr_repo ? aws_ecr_repository.this[0].id : var.ecr_repo
  image_tag      = coalesce(var.image_tag, formatdate("YYYYMMDDhhmmss", timestamp()))
  ecr_image_name = format("%v/%v:%v", local.ecr_address, local.ecr_repo, local.image_tag)
}

resource "docker_registry_image" "this" {
  name = local.ecr_image_name

  build {
    context    = var.source_path
    dockerfile = var.docker_file_path
    build_args = var.build_args
  }

  keep_remotely = var.keep_remotely
}

resource "aws_ecr_repository" "this" {
  count = var.create_ecr_repo ? 1 : 0

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
