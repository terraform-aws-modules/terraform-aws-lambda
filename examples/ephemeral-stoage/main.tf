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

module "lambda_function" {
  source = "../../"

  publish = true

  function_name     = "${random_pet.this.id}-lambda-ephemeral-stoage"
  handler           = "index.lambda_handler"
  runtime           = "python3.8"
  ephemeral_storage = 10240

}

