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

module "lambda_function_in_vpc" {
  source = "../../"

  function_name = "${random_pet.this.id}-lambda-in-vpc"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  source_path = "${path.module}/../fixtures/python3.8-app1"

  vpc_subnet_ids         = module.vpc.intra_subnets
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  attach_network_policy  = true
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = random_pet.this.id
  cidr = "10.10.0.0/16"

  azs           = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  intra_subnets = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]

  # Add public_subnets and NAT Gateway to allow access to internet from Lambda
  # public_subnets  = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  # enable_nat_gateway = true
}
