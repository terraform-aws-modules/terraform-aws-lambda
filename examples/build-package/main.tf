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

#################
# Build packages
#################

//module "package1" {
//  source = "../../"
//
//  create_function = false
//  source_path = "${path.module}/../fixtures/python3.8-app1"
//}
//
//module "package2" {
//  source = "../../"
//
//  create_function = false
//  source_path = [
//    "${path.module}/../fixtures/python3.8-app1"
//  ]
//}
//
//module "package3" {
//  source = "../../"
//
//  create_function = false
//  source_path = [
//    "${path.module}/../fixtures/python3.8-app1/dir1",
//    {
//      path = "${path.module}/../fixtures/python3.8-app1",
//      patterns = [
//        "!.*/.*\\.txt",
//        ".*"
//      ]
//    }
//  ]
//}
//
//module "package4" {
//  source = "../../"
//
//  create_function = false
//  source_path = [
//    "${path.module}/../fixtures/python3.8-app1/dir1",
//    {
//      path = "${path.module}/../fixtures/python3.8-app1",
//      patterns = [
//        "!.*/.*\\.txt",
//        ".*"
//      ]
//    }
//  ]
//
//  #####
//  build_in_docker = true
//  #####
//
//}
//
//############################
//# Build packages and deploy
//############################
//
module "lambda_layer" {
  source = "../../"

  create_layer        = true
  layer_name          = "${random_pet.this.id}-layer"
  compatible_runtimes = ["python3.8"]

  source_path = "${path.module}/../fixtures/python3.8-app1"

  build_in_docker = true
  runtime         = "python3.8"
  docker_file     = "${path.module}/../fixtures/python3.8-app1/docker/Dockerfile"
}
//
//module "lambda_function" {
//  source = "../../"
//
//  function_name = "${random_pet.this.id}-function"
//  handler       = "index.lambda_handler"
//  runtime       = "python3.8"
//
//  source_path = "${path.module}/../fixtures/python3.8-app1"
//
//  layers = [
//    module.lambda_layer.this_lambda_layer_arn
//  ]
//}

//#######################
//# Deploy from packaged
//#######################
//
//module "lambda_layer_from_package" {
//  source = "../../"
//
//  create_package         = false
//  local_existing_package = module.package4.local_filename
//
//  create_layer        = true
//  layer_name          = "${random_pet.this.id}-layer-packaged"
//  compatible_runtimes = ["python3.8"]
//}
//
//module "lambda_function_from_package" {
//  source = "../../"
//
//  create_package = false
//  local_existing_package = module.package3.local_filename
//
//  function_name = "${random_pet.this.id}-function-packaged"
//  handler       = "index.lambda_handler"
//  runtime       = "python3.8"
//
//  layers = [
//    module.lambda_layer_from_package.this_lambda_layer_arn
//  ]
//}
//
