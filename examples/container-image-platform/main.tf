data "aws_region" "current" {}

data "aws_caller_identity" "this" {}

data "aws_ecr_authorization_token" "token" {}

provider "aws" {
  region = "us-east-1"
}

provider "docker" {
  registry_auth {
    address  = format("%v.dkr.ecr.%v.amazonaws.com", data.aws_caller_identity.this.account_id, data.aws_region.current.name)
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

resource "random_pet" "this" {
  length = 2
}

module "docker_image" {
  source = "../../modules/docker-build"

  create_ecr_repo  = true
  ecr_repo         = random_pet.this.id
  ecr_force_delete = true
  # docker tag
  image_tag = "0.1"

  # the path where the dockerfile and lambda src is located
  source_path = "${path.cwd}/context"

  # build args
  build_args = {
    FOO = "bar"
  }
}

module "lambda_function_from_container_image" {
  source = "../../"

  function_name = "${random_pet.this.id}-lambda-from-container-image"
  description   = "My x86_64 lambda function built from non x86_64 machine."

  create_package = false

  image_uri    = module.docker_image.image_uri
  package_type = "Image"

  # define the architecture the lambda function will use
  architectures = ["x86_64"]
}
