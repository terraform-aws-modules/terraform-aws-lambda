provider "aws" {
  region = "eu-west-1"
  #  region = "us-east-1"

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

resource "random_pet" "this" {
  length = 2
}

#module "lambda_at_edge" {
#  source = "../../"
#
#  function_name = "${random_pet.this.id}-lambda-edge"
#  handler       = "index.lambda_handler"
#  runtime       = "python3.12"
#  lambda_at_edge = true
#
#  attach_cloudwatch_logs_policy = true
#
#  source_path = "${path.module}/../fixtures/python-app1/"
#}

#resource "aws_cloudwatch_log_group" "this" {
#  name = "/aws/lambda/us-east-1.${random_pet.this.id}-lambda-simple"
#}

module "lambda_function" {
  source = "../../"

  publish = true

  function_name = "${random_pet.this.id}-lambda-simple"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"

  # role_maximum_session_duration = 7200

  #  attach_cloudwatch_logs_policy = false

  #  use_existing_cloudwatch_log_group = true

  #  lambda_at_edge = true

  #  independent_file_timestamps = true

  #  store_on_s3 = true
  #  s3_bucket   = module.s3_bucket.s3_bucket_id

  #  create_package         = false
  #  local_existing_package = data.null_data_source.downloaded_package.outputs["filename"]

  # snap_start = true

  #  policy_json = <<EOF
  #{
  #    "Version": "2012-10-17",
  #    "Statement": [
  #        {
  #            "Effect": "Allow",
  #            "Action": [
  #                "xray:GetSamplingStatisticSummaries"
  #            ],
  #            "Resource": ["*"]
  #        }
  #    ]
  #}
  #EOF
  #
  #  policy   = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
  #  policies = ["arn:aws:iam::aws:policy/AWSXrayReadOnlyAccess"]
  #
  #  policy_statements = {
  #    dynamodb = {
  #      effect    = "Allow",
  #      actions   = ["dynamodb:BatchWriteItem"],
  #      resources = ["arn:aws:dynamodb:eu-west-1:052212379155:table/Test"]
  #    },
  #    s3_read = {
  #      effect    = "Deny",
  #      actions   = ["s3:HeadObject", "s3:GetObject"],
  #      resources = ["arn:aws:s3:::my-bucket/*"]
  #    }
  #  }

  #  source_path = "${path.module}/../fixtures/python-app1/"

  #  source_path = [
  #    "${path.module}/../fixtures/python-app1/index.py",
  #    {
  #      pip_requirements = "${path.module}/../fixtures/python-app1/requirements.txt"
  #      prefix_in_zip = "vendor"
  #    }
  #  ]

  #  source_path = [
  #    "${path.module}/../fixtures/python-app1/index.py",
  #    "${path.module}/../fixtures/python-app1/dir1/dir2",
  #    {
  #      pip_requirements = "${path.module}/../fixtures/python-app1/requirements.txt"
  #    }
  #  ]

  #  source_path = [
  #    {
  #      path = "${path.module}/../fixtures/python-app1"
  #    }
  #  ]

  #  source_path = [
  #    {
  #      path = "${path.module}/../fixtures/python-app1"
  #      pip_requirements = false
  #    }
  #  ]

  #  source_path = [
  #    {
  #      path = "${path.module}/../fixtures/python-app1"
  #      pip_requirements = true
  #    }
  #  ]

  #  source_path = [
  #    {
  #      path = "${path.module}/../fixtures/python-app1"
  #      commands = [
  #        ":zip",
  #        "cd `mktemp -d`",
  #        "pip install --target=. -r ${path.module}/../fixtures/python-app1/requirements.txt",
  #        ":zip . vendor/",
  #      ]
  #      patterns = [
  #        "!vendor/colorful-0.5.4.dist-info/RECORD",
  #        "!vendor/colorful-.+.dist-info/.*",
  #        "!vendor/colorful/__pycache__/?.*",
  #      ]
  #    }
  #  ]

  source_path = [
    #    {
    #      pip_requirements = "${path.module}/../fixtures/python-app1/requirements.txt"
    #      pip_requirements = "${path.module}/../deploy/requirements.txt"
    #    },
    "${path.module}/../fixtures/python-app1/index.py",
    #    {
    #      path = "${path.module}/../fixtures/python-app1/index.py"
    #      patterns = <<END
    #        # To use comments in heredoc patterns set the env var:
    #        # export TF_LAMBDA_PACKAGE_PATTERN_COMMENTS=true
    #        # The intent for comments just to use in examples and demo snippets.
    #        # To write a comment start it with double spaces and the # sign
    #        # if it follows a pattern.
    #
    #        !index\.py         # Exclude a file with 'index.py' name
    #        index\..*          # Re-include
    #      END
    #    },
    #    {
    #      path = "${path.module}/../fixtures/dirtree"
    #      #      prefix_in_zip = "vendor"
    #      patterns = <<END
    #        # To see step by step output how files and folders was skipped or added
    #        # set an env var in your shell by a command similar to:
    #        # export TF_LAMBDA_PACKAGE_LOG_LEVEL=DEBUG
    #
    #        # To play with this demo pattern you can go to a ../fixtures folder
    #        # and run there a dirtree.sh script to create a demo dirs tree
    #        # matchable by following patterns.
    #
    #      # !abc/.*           # Filter out everything in an abc folder with the folder itself
    #      # !abc/.+           # Filter out just all folder's content but keep the folder even if it's empty
    #         abc/def/.*       # Re-include everything in abc/def sub folder
    #      # !abc/def/ghk/.*   # Filter out again in abc/def/ghk sub folder
    #        !.*/fiv.*
    #        !.*/zi--.*
    #
    #        ########################################################################
    #        # Special cases
    #
    #        # !.*/  # Removes all explicit directories from a zip file, mean while
    #                # the zip file still valid and unpacks correctly but will not
    #                # contain any empty directories.
    #
    #        # !.*/bar/  # To remove just some directory use more qualified path to it.
    #
    #        # !([^/]+/){3,}  # Remove all directories more than 3 folders in depth.
    #      END
    #    }
  ]

  #  source_path = [
  #    {
  #      #      path = "${path.module}/../fixtures/python-app1"
  #
  #      #      pip_requirements = true
  #      pip_requirements = "${path.module}/../fixtures/python-app1/requirements.txt"
  #      prefix_in_zip = "vendor"
  #      #      commands = ["pip install -r requirements.txt"]
  #
  #      #      patterns = <<END
  #      #        !.*/.*\.txt       # Filter all txt files recursively
  #      #        node_modules/.*   # Include empty dir or with a content if it exists
  #      #        node_modules/.+   # Include full non empty node_modules dir with its content
  #      #        node_modules/     # Include node_modules itself without its content
  #      #                          # It's also a way to include an empty dir if it exists
  #      #        node_modules      # Include a file or an existing dir only
  #      #
  #      #        !abc/.*           # Filter out everything in an abc folder
  #      #        abc/def/.*        # Re-include everything in abc/def sub folder
  #      #        !abc/def/ghk/.*   # Filter out again in abc/def/ghk sub folder
  #      #      END
  #
  #      patterns = [
  #        "**/*.txt",
  #        "",
  #        "",
  #      ]
  #    },
  #
  #  ]

  #  source_path = [
  #    "${path.module}/../fixtures/python-app1-extra",
  #    {
  #      path = "${path.module}/../fixtures/python-appsadasdasd"
  #      prefix_in_zip = "foo/bar-bla",
  #      match = [
  #        "**/*.txt",
  #        "",
  #        "",
  #      ]
  #    },
  #    {
  #      path = "${path.module}/../fixtures/python-app1"
  #      pip_requirements = true
  #      prefix_in_zip = "foo/bar",
  #      match = [
  #        "**/*.txt",
  #        "",
  #        "",
  #      ]
  #    },
  #    {
  #      path = "${path.module}/../fixtures/python-app1"
  #      pip_requirements = "requirements.txt"
  #      prefix_in_zip = "foo/bar",
  #      match = [
  #        "!.*/.*\\.txt",
  #        "",
  #      ]
  #    },
  #    {
  #      path = "${path.module}/../fixtures/python-app1"
  #      commands = [
  #        "npm install",
  #        ":zip"
  #      ]
  #      prefix_in_zip = "foo/bar",
  #      patterns = [
  #        "!.*/.*\\.txt", # Filter all txt files recursively
  #        "node_modules/.+", # Include
  #      ]
  #    },
  #    {
  #      path = "${path.module}/../fixtures/python-app1"
  #      commands = [
  #        "npm install",
  #        ":zip"
  #      ]
  #      prefix_in_zip = "foo/bar", # By default everything installs into the root of a zip package
  #      patterns = <<END
  #        !.*/.*\.txt       # Filter all txt files recursively
  #        node_modules/.*   # Include empty dir or with a content if it exists
  #        node_modules/.+   # Include full non empty node_modules dir with its content
  #        node_modules/     # Include node_modules itself without its content
  #                          # It's also a way to include an empty dir if it exists
  #        node_modules      # Include a file or an existing dir only
  #
  #        !abc/.*           # Filter out everything in an abc folder
  #        abc/def/.*        # Re-include everything in abc/def sub folder
  #        !abc/def/ghk/*    # Filter out again in abc/def/ghk sub folder
  #      END
  #    },
  #    {
  #      path = "${path.module}/../fixtures/python-app1"
  #      commands = [
  #        "npm install",
  #        ":zip"
  #      ]
  #      prefix_in_zip = "foo/bar",
  #      patterns = [".*"]  # default
  #    }
  #  ]

  #  build_in_docker = true
  #  docker_pip_cache = true
  #  docker_with_ssh_agent = true
  #  docker_file = "${path.module}/../fixtures/python-app1/docker/Dockerfile"
  #  docker_build_root = "${path.module}/../../docker"
  #  docker_image = "public.ecr.aws/sam/build-python3.12"
}

####
# Download from remote and upload to S3
####
#locals {
#  package_url = "https://github.com/antonbabenko/terraform-aws-anything/archive/master.zip"
#  downloaded  = "downloaded_package_${md5(local.package_url)}.zip"
#}
#
#resource "null_resource" "download_package" {
#  triggers = {
#    downloaded = local.downloaded
#  }
#
#  provisioner "local-exec" {
#    command = "curl -L -o ${local.downloaded} ${local.package_url}"
#  }
#}
#
#data "null_data_source" "downloaded_package" {
#  inputs = {
#    id       = null_resource.download_package.id
#    filename = local.downloaded
#  }
#}
