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

  function_name = "${random_pet.this.id}-lambda-simple"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  attach_cloudwatch_logs_policy = false

  //  independent_file_timestamps = true

  //  store_on_s3 = true
  //  s3_bucket   = module.s3_bucket.this_s3_bucket_id

  //  create_package         = false
  //  local_existing_package = data.null_data_source.downloaded_package.outputs["filename"]

//
//  policy_json = <<EOF
//{
//    "Version": "2012-10-17",
//    "Statement": [
//        {
//            "Effect": "Allow",
//            "Action": [
//                "xray:GetSamplingStatisticSummaries"
//            ],
//            "Resource": ["*"]
//        }
//    ]
//}
//EOF
//
//  policy   = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
//  policies = ["arn:aws:iam::aws:policy/AWSXrayReadOnlyAccess"]
//
//  policy_statements = {
//    dynamodb = {
//      effect    = "Allow",
//      actions   = ["dynamodb:BatchWriteItem"],
//      resources = ["arn:aws:dynamodb:eu-west-1:052212379155:table/Test"]
//    },
//    s3_read = {
//      effect    = "Deny",
//      actions   = ["s3:HeadObject", "s3:GetObject"],
//      resources = ["arn:aws:s3:::my-bucket/*"]
//    }
//  }

  source_path = "${path.module}/../fixtures/python3.8-app1"
  //  source_path = [
  //    "${path.module}/../fixtures/python3.8-app1-extra",
  //    {
  //      path = "${path.module}/../fixtures/python3.8-appsadasdasd"
  //      prefix_in_zip = "foo/bar-bla",
  //      match = [
  //        "**/*.txt",
  //        "",
  //        "",
  //      ]
  //    },
  //    {
  //      path = "${path.module}/../fixtures/python3.8-app1"
  //      pip_requirements = true
  //      prefix_in_zip = "foo/bar",
  //      match = [
  //        "**/*.txt",
  //        "",
  //        "",
  //      ]
  //    },
  //    {
  //      path = "${path.module}/../fixtures/python3.8-app1"
  //      pip_requirements = "requirements.txt"
  //      prefix_in_zip = "foo/bar",
  //      match = [
  //        "!.*/.*\\.txt",
  //        "",
  //      ]
  //    },
  //    {
  //      path = "${path.module}/../fixtures/python3.8-app1"
  //      commands = ["npm install"]
  //      prefix_in_zip = "foo/bar",
  //      patterns = [
  //        "!.*/.*\\.txt", # Filter all txt files recursively
  //        "node_modules/.+", # Include
  //      ]
  //    },
  //    {
  //      path = "${path.module}/../fixtures/python3.8-app1"
  //      commands = ["npm install"]
  //      prefix_in_zip = "foo/bar", # By default everything installs into the root of a zip package
  //      patterns = <<END
  //        !.*/.*\.txt       # Filter all txt files recursively
  //        node_modules/.*   # Include empty dir or with a content if it exists
  //        node_modules/.+   # Include full non empty node_modules dir with its content
  //        node_modules/     # Include node_modules itself without its content
  //                          # It's also a way to include an empty dir if it exists
  //        node_modules      # Include a file or an existing dir only
  //
  //        !abc/.*           # Filter out everything in an abc folder
  //        abc/def/.*        # Re-include everything in abc/def sub folder
  //        !abc/def/hgk/*    # Filter out again in abc/def/hgk sub folder
  //      END
  //    },
  //    {
  //      path = "${path.module}/../fixtures/python3.8-app1"
  //      commands = ["npm install"]
  //      prefix_in_zip = "foo/bar",
  //      patterns = [".*"]  # default
  //    }
  //  ]

  //    build_in_docker = true
  //    docker_file = "${path.module}/../fixtures/python3.8-app1/docker/Dockerfile"
  //    docker_build_root = "${path.module}/../../docker"
  //  #docker_image = "lambci/lambda:build-python3.8"
  //  #docker_with_ssh_agent = true
}

####
# Download from remote and upload to S3
####
//locals {
//  package_url = "https://github.com/antonbabenko/terraform-aws-anything/archive/master.zip"
//  downloaded  = "downloaded_package_${md5(local.package_url)}.zip"
//}
//
//resource "null_resource" "download_package" {
//  triggers = {
//    downloaded = local.downloaded
//  }
//
//  provisioner "local-exec" {
//    command = "curl -L -o ${local.downloaded} ${local.package_url}"
//  }
//}
//
//data "null_data_source" "downloaded_package" {
//  inputs = {
//    id       = null_resource.download_package.id
//    filename = local.downloaded
//  }
//}
