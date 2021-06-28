provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

resource "random_pet" "this" {
  length = 2
}

module "lambda_function_from_container_image" {
  source = "../../"

  function_name = "${random_pet.this.id}-lambda-from-container-image"
  description   = "My awesome lambda function from container image"

  create_package = false

  ##################
  # Container Image
  ##################
  image_uri    = module.docker_image.image_uri
  package_type = "Image"
}

module "docker_image" {
  source = "../../modules/docker-build"

  create_ecr_repo = true
  ecr_repo        = random_pet.this.id
  image_tag       = "1.0"
  source_path     = "context"
}
