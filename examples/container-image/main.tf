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

module "lambda_function_with_container_image" {
  source = "../../"

  function_name = "${random_pet.this.id}-lambda-with-container"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  create_package = false

  ######################
  # Container Image
  ######################

  image_uri = "112233445566.dkr.ecr.eu-west-1.amazonaws.com/test-lambda:latest"
  package_type = "Image"
}
