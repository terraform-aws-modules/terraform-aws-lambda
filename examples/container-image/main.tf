data "aws_region" "current" {}

data "aws_caller_identity" "this" {}

data "aws_ecr_authorization_token" "token" {}

locals {
  source_path   = "context"
  path_include  = ["**"]
  path_exclude  = ["**/__pycache__/**"]
  files_include = setunion([for f in local.path_include : fileset(local.source_path, f)]...)
  files_exclude = setunion([for f in local.path_exclude : fileset(local.source_path, f)]...)
  files         = sort(setsubtract(local.files_include, local.files_exclude))

  dir_sha = sha1(join("", [for f in local.files : filesha1("${local.source_path}/${f}")]))
}

provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

provider "docker" {
  registry_auth {
    address  = format("%v.dkr.ecr.%v.amazonaws.com", data.aws_caller_identity.this.account_id, data.aws_region.current.region)
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

module "lambda_function_with_docker_build" {
  source = "../../"

  function_name = "${random_pet.this.id}-lambda-with-docker-build"
  description   = "My awesome lambda function with container image by modules/docker-build"

  create_package = false

  ##################
  # Container Image
  ##################
  package_type  = "Image"
  architectures = ["arm64"] # ["x86_64"]

  image_uri = module.docker_build.image_uri
}

module "lambda_function_with_docker_build_from_ecr" {
  source = "../../"

  function_name = "${random_pet.this.id}-lambda-with-docker-build-from-ecr"
  description   = "My awesome lambda function with container image by modules/docker-build and ECR repository created by terraform-aws-ecr module"

  create_package = false

  ##################
  # Container Image
  ##################
  package_type  = "Image"
  architectures = ["arm64"] # ["x86_64"]

  image_uri = module.docker_build_from_ecr.image_uri
}

module "docker_build" {
  source = "../../modules/docker-build"

  create_ecr_repo = true
  ecr_repo        = random_pet.this.id
  ecr_repo_lifecycle_policy = jsonencode({
    "rules" : [
      {
        "rulePriority" : 1,
        "description" : "Keep only the last 2 images",
        "selection" : {
          "tagStatus" : "any",
          "countType" : "imageCountMoreThan",
          "countNumber" : 2
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
  })

  use_image_tag = false # If false, sha of the image will be used

  # use_image_tag = true
  # image_tag   = "2.0"

  source_path = local.source_path
  platform    = "linux/amd64"
  build_args = {
    FOO = "bar"
  }

  triggers = {
    dir_sha = local.dir_sha
  }
}

############################################
# Docker Image and ECR by terraform-aws-ecr
############################################

module "docker_build_from_ecr" {
  source = "../../modules/docker-build"

  ecr_repo = module.ecr.repository_name

  use_image_tag = false # If false, sha of the image will be used

  # use_image_tag = true
  # image_tag   = "2.0"

  source_path = local.source_path
  platform    = "linux/amd64"
  build_args = {
    FOO = "bar"
  }
  # Can also use buildx
  builder          = "default"
  docker_file_path = "${local.source_path}/Dockerfile"

  triggers = {
    dir_sha = local.dir_sha
  }

  cache_from = ["${module.ecr.repository_url}:latest"]
}

module "docker_build_multistage" {
  source = "../../modules/docker-build"

  ecr_repo = module.ecr.repository_name

  use_image_tag = true
  image_tag     = "first_stage"

  source_path = local.source_path
  platform    = "linux/amd64"
  build_args = {
    FOO = "bar"
  }
  builder          = "default"
  docker_file_path = "${local.source_path}/Dockerfile"

  # multi-stage builds
  build_target = "first_stage"

  triggers = {
    dir_sha = local.dir_sha
  }

  cache_from = ["${module.ecr.repository_url}:latest"]
}

module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name         = "${random_pet.this.id}-ecr"
  repository_force_delete = true

  create_lifecycle_policy = false

  repository_lambda_read_access_arns = [module.lambda_function_with_docker_build_from_ecr.lambda_function_arn]
}

resource "random_pet" "this" {
  length = 2
}
