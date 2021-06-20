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

  function_name = "${random_pet.this.id}-lambda-from-created-image"
  description   = "My awesome lambda function from container image using build module"

  create_package = false
  create_image   = true
  create_repo    = true

  ##################
  # Container Image
  ##################
  package_type = "Image"
  source_path  = "context"
  image_repo   = "${random_pet.this.id}-lambda-repo"
  image_tag    = "1.0"
}
