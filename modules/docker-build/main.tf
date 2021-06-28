data "aws_region" "current" {}

data "aws_caller_identity" "this" {}

data "aws_ecr_authorization_token" "token" {}

locals {
  ecr_address    = format("%v.dkr.ecr.%v.amazonaws.com", data.aws_caller_identity.this.account_id, data.aws_region.current.name)
  ecr_repo       = var.create_ecr_repo ? aws_ecr_repository.this[0].id : var.ecr_repo
  image_tag      = coalesce(var.image_tag, formatdate("YYYYMMDDhhmmss", timestamp()))
  ecr_image_name = format("%v/%v:%v", local.ecr_address, local.ecr_repo, local.image_tag)
}

provider "docker" {
  registry_auth {
    address  = local.ecr_address
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

resource "docker_registry_image" "this" {
  name = local.ecr_image_name

  build {
    context    = var.source_path
    dockerfile = var.docker_file_path
  }
}

resource "aws_ecr_repository" "this" {
  count = var.create_ecr_repo ? 1 : 0

  name = var.ecr_repo
}
