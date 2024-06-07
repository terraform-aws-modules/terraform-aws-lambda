provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

resource "random_pet" "this" {
  length = 2
}

module "lambda_function" {
  source = "../../"

  function_name = "${random_pet.this.id}-lambda-simple"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"

  source_path = [
    "${path.module}/src/python-app1",
  ]
  trigger_on_package_timestamp = false
}
