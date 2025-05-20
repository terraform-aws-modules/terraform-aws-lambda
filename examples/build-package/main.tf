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

#################
# Build packages
#################

# Create zip-archive of a single directory where "pip install" will also be executed (default for python runtime with requirements.txt present)
module "package_dir" {
  source = "../../"

  create_function = false

  build_in_docker = true
  runtime         = "python3.12"
  source_path     = "${path.module}/../fixtures/python-app1"
  artifacts_dir   = "${path.root}/builds/package_dir/"
}

# Create zip-archive of a single directory where "pip install" will also be executed (default for python runtime with requirements.txt present) and set temporary directory for pip install
module "package_dir_pip_dir" {
  source = "../../"

  create_function = false

  build_in_docker = true
  runtime         = "python3.12"
  source_path = [{
    path             = "${path.module}/../fixtures/python-app1"
    pip_tmp_dir      = "${path.cwd}/../fixtures"
    pip_requirements = "${path.module}/../fixtures/python-app1/requirements.txt"
  }]
  artifacts_dir = "${path.root}/builds/package_dir_pip_dir/"
}

# Create zip-archive of a single directory where "poetry export" & "pip install --no-deps" will also be executed (using docker)
module "package_dir_poetry" {
  source = "../../"

  create_function = false

  build_in_docker = true
  runtime         = "python3.12"
  docker_image    = "build-python-poetry"
  docker_file     = "${path.module}/../fixtures/python-app-poetry/docker/Dockerfile"

  source_path = [
    {
      path           = "${path.module}/../fixtures/python-app-poetry"
      poetry_install = true
    }
  ]
  artifacts_dir = "${path.root}/builds/package_dir_poetry/"
}

# Create zip-archive of a src directory where "poetry export" & "pip install --no-deps" will also be executed (using docker)
module "package_src_poetry" {
  source = "../../"

  create_function = false

  build_in_docker = true
  runtime         = "python3.12"
  docker_image    = "build-python-poetry"
  docker_file     = "${path.module}/../fixtures/python-app-src-poetry/docker/Dockerfile"

  source_path = [
    "${path.module}/../fixtures/python-app-src-poetry/src",
    {
      path           = "${path.module}/../fixtures/python-app-src-poetry/pyproject.toml"
      poetry_install = true
    }
  ]
  artifacts_dir = "${path.root}/builds/package_src_poetry/"
}

# Create zip-archive of a src directory where "poetry export" & "pip install --no-deps" will also be executed (using docker)
module "package_src_poetry2" {
  source = "../../"

  create_function = false

  build_in_docker = true
  runtime         = "python3.12"
  docker_image    = "build-python-poetry"
  docker_file     = "${path.module}/../fixtures/python-app-src-poetry/docker/Dockerfile"

  source_path = [
    "${path.module}/../fixtures/python-app-src-poetry/src",
    "${path.module}/../fixtures/python-app-src-poetry/pyproject.toml"
  ]
  artifacts_dir = "${path.root}/builds/package_src_poetry2/"
}

# Create zip-archive of a single directory where "poetry export" & "pip install --no-deps" will also be executed (not using docker)
module "package_dir_poetry_no_docker" {
  source = "../../"

  create_function = false

  runtime = "python3.12"

  source_path = [
    {
      path           = "${path.module}/../fixtures/python-app-poetry"
      poetry_install = true
    }
  ]
  artifacts_dir = "${path.root}/builds/package_dir_poetry/"
}

# Create zip-archive of a single directory without running "pip install" (which is default for python runtime)
module "package_dir_without_pip_install" {
  source = "../../"

  create_function = false

  runtime = "python3.12"
  source_path = [
    {
      path             = "${path.module}/../fixtures/python-app1"
      pip_requirements = false
      # pip_requirements = true  # Will run "pip install" with default requirements.txt
    }
  ]
}

# Create zip-archive of a single file (without running "pip install")
module "package_file" {
  source = "../../"

  create_function = false

  runtime     = "python3.12"
  source_path = "${path.module}/../fixtures/python-app1/index.py"
}

# Create zip-archive which contains:
# 1. A single file - index.py
# 2. Run "pip install" with specified requirements.txt into "vendor" directory inside of zip-archive
module "package_file_with_pip_requirements" {
  source = "../../"

  create_function = false

  runtime = "python3.12"
  source_path = [
    "${path.module}/../fixtures/python-app1/index.py",
    {
      pip_requirements = "${path.module}/../fixtures/python-app1/requirements.txt"
      prefix_in_zip    = "vendor"
    }
  ]
}

# Create zip-archive which contains:
# 1. A single file - index.py
# 2. Content of directory "dir2"
# 3. Install pip requirements
# "pip install" is running in a Docker container for the specified runtime
module "package_with_pip_requirements_in_docker" {
  source = "../../"

  create_function = false

  runtime = "python3.12"
  source_path = [
    "${path.module}/../fixtures/python-app1/index.py",
    "${path.module}/../fixtures/python-app1/dir1/dir2",
    {
      pip_requirements = "${path.module}/../fixtures/python-app1/requirements.txt"
    }
  ]

  build_in_docker = true
}

# Create zip-archive which contains:
# 1. A single file - index.py
# 2. Content of directory "dir2"
# 3. Install pip requirements
# "pip install" is running in a Docker container for the specified runtime
# The docker entrypoint is overridden, allowing you to run additional commands within the container
module "package_with_pip_requirements_in_docker_overriding_entrypoint" {
  source = "../../"

  create_function = false

  runtime = "python3.12"
  source_path = [
    "${path.module}/../fixtures/python-app1/index.py",
    "${path.module}/../fixtures/python-app1/dir1/dir2",
    {
      pip_requirements = "${path.module}/../fixtures/python-app1/requirements.txt"
    }
  ]
  hash_extra = "package_with_pip_requirements_in_docker_overriding_entrypoint"

  build_in_docker = true
  docker_additional_options = [
    "-e", "MY_ENV_VAR='My environment variable value'",
    "-v", "${abspath(path.module)}/../fixtures/python-app1/docker/entrypoint.sh:/entrypoint/entrypoint.sh:ro",
  ]
  docker_entrypoint = "/entrypoint/entrypoint.sh"
}

# Create zip-archive which contains content of directory with commands and patterns applied.
#
# Notes:
# 1. `:zip` is a special command which creates content of current working
#    directory (first argument) and places it inside of path (second argument).
# 2. Patterns (Python Regex) apply to all elements before putting them in zip-archive
module "package_with_commands_and_patterns" {
  source = "../../"

  create_function = false

  runtime = "python3.12"
  source_path = [
    {
      path = "${path.module}/../fixtures/python-app1"
      commands = [
        ":zip",
        "cd `mktemp -d`",
        "pip install --target=. -r ${abspath(path.module)}/../fixtures/python-app1/requirements.txt",
        ":zip . vendor/",
      ]
      patterns = [
        "!vendor/colorful-0.5.4.dist-info/RECORD",
        "!vendor/colorful-.+.dist-info/.*",
        "!vendor/colorful/__pycache__/?.*",
      ]
    }
  ]
}

# Some use cases might require the production packages are deployed while maintaining local node_modules folder
# This example saves the node_modules folder by moving it to an ignored directory
# After the zip file is created with production node_modules, the dev node_modules folder is restored
module "npm_package_with_commands_and_patterns" {
  source = "../../"

  create_function = false

  runtime = "nodejs18.x"
  source_path = [
    {
      path = "${path.module}/../fixtures/node-app"
      commands = [
        "[ ! -d node_modules ] || mv node_modules node_modules_temp",
        "npm install --production",
        ":zip",
        "rm -rf node_modules",
        "[ ! -d node_modules_temp ] || mv node_modules_temp node_modules",
      ]
      patterns = [
        "!node_modules_temp/.*"
      ]
    }
  ]
}
# Create zip-archive with various sources and patterns.
# Note, that it is possible to write comments in patterns.
module "package_with_patterns" {
  source = "../../"

  create_function = false

  runtime = "python3.12"
  source_path = [
    {
      pip_requirements = "${path.module}/../fixtures/python-app1/requirements.txt"
    },
    "${path.module}/../fixtures/python-app1/index.py",
    {
      path     = "${path.module}/../fixtures/python-app1/index.py"
      patterns = <<END
            # To use comments in heredoc patterns set the env var:
            # export TF_LAMBDA_PACKAGE_PATTERN_COMMENTS=true
            # The intent for comments just to use in examples and demo snippets.
            # To write a comment start it with double spaces and the # sign
            # if it follows a pattern.

            !index\.py         # Exclude a file with 'index.py' name
            index\..*          # Re-include
          END
    },
    {
      path          = "${path.module}/../fixtures/dirtree"
      prefix_in_zip = "vendor"
      patterns      = <<END
            # To see step by step output how files and folders was skipped or added
            # set an env var in your shell by a command similar to:
            # export TF_LAMBDA_PACKAGE_LOG_LEVEL=DEBUG

            # To play with this demo pattern you can go to a ../fixtures folder
            # and run there a dirtree.sh script to create a demo dirs tree
            # matchable by following patterns.

            !abc/.*           # Filter out everything in an abc folder with the folder itself
            !abc/.+           # Filter out just all folder's content but keep the folder even if it's empty
            abc/def/.*        # Re-include everything in abc/def sub folder
            !abc/def/ghk/.*   # Filter out again in abc/def/ghk sub folder
            !.*/fiv.*
            !.*/zi--.*

            ########################################################################
            # Special cases

            # !.*/  # Removes all explicit directories from a zip file, mean while
                    # the zip file still valid and unpacks correctly but will not
                    # contain any empty directories.

            # !.*/bar/  # To remove just some directory use more qualified path to it.

            # !([^/]+/){3,}  # Remove all directories more than 3 folders in depth.
          END
    }
  ]
}

# Create zip-archive with the dependencies specified in requirements.txt
# which will be building in a docker container where SSH agent will be available
# (to access private repositories, for example).
module "package_with_docker" {
  source = "../../"

  create_function = false

  runtime = "python3.12"
  source_path = [
    "${path.module}/../fixtures/python-app1/index.py",
    "${path.module}/../fixtures/python-app1/dir1/dir2",
    {
      pip_requirements = "${path.module}/../fixtures/python-app1/requirements.txt"
    }
  ]
  hash_extra = "something-unique-to-not-conflict-with-module.package_with_pip_requirements_in_docker"

  build_in_docker       = true
  docker_pip_cache      = true
  docker_with_ssh_agent = true
  #  docker_file           = "${path.module}/../fixtures/python-app1/docker/Dockerfile"
  docker_build_root = "${path.module}/../fixtures/python-app1/docker"
  docker_image      = "public.ecr.aws/sam/build-python3.12:latest"
}

# Create zip-archive of a single directory where "npm install" will also be executed (default for nodejs runtime)
module "package_dir_with_npm_install" {
  source = "../../"

  create_function = false

  runtime     = "nodejs14.x"
  source_path = "${path.module}/../fixtures/nodejs14.x-app1"
}

# Create zip-archive of a single directory where "npm install" will also be
# executed (default for nodejs runtime). This example has package-lock.json which
# is respected when installing dependencies.
module "package_dir_with_npm_install_lock_file" {
  source = "../../"

  create_function = false

  runtime     = "nodejs14.x"
  source_path = "${path.module}/../fixtures/nodejs14.x-app2"
}

# Create zip-archive of a single directory without running "npm install" (which is the default for nodejs runtime)
module "package_dir_without_npm_install" {
  source = "../../"

  create_function = false

  runtime = "nodejs14.x"
  source_path = [
    {
      path             = "${path.module}/../fixtures/nodejs14.x-app1"
      npm_requirements = false
      # npm_requirements = true  # Will run "npm install" with package.json
    }
  ]
}

# Create zip-archive of a single directory where "npm install" will also be executed using docker
module "package_with_npm_requirements_in_docker" {
  source = "../../"

  create_function = false

  runtime         = "nodejs14.x"
  source_path     = "${path.module}/../fixtures/nodejs14.x-app1"
  build_in_docker = true
  hash_extra      = "something-unique-to-not-conflict-with-module.package_dir_with_npm_install"
}

# Create zip-archive of a single directory where "npm install" will also be
# executed using docker. This example has package-lock.json which is respected
# when installing dependencies.
module "package_with_npm_lock_in_docker" {
  source = "../../"

  create_function = false

  runtime         = "nodejs14.x"
  source_path     = "${path.module}/../fixtures/nodejs14.x-app2"
  build_in_docker = true
  hash_extra      = "something-unique-to-not-conflict-with-module.package_dir_with_npm_install"
}

################################
# Build package in Docker and
# use it to deploy Lambda Layer
################################

module "lambda_layer" {
  source = "../../"

  create_layer        = true
  layer_name          = "${random_pet.this.id}-layer-dockerfile"
  compatible_runtimes = ["python3.12"]

  source_path = "${path.module}/../fixtures/python-app1"
  hash_extra  = "extra-hash-to-prevent-conflicts-with-module.package_dir"

  build_in_docker = true
  runtime         = "python3.12"
  docker_image    = "public.ecr.aws/sam/build-python3.12:latest"
  docker_file     = "${path.module}/../fixtures/python-app1/docker/Dockerfile"
  artifacts_dir   = "${path.root}/builds/lambda_layer/"
}

module "lambda_layer_poetry" {
  source = "../../"

  create_layer        = true
  layer_name          = "${random_pet.this.id}-layer-poetry-dockerfile"
  compatible_runtimes = ["python3.12"]

  source_path = [
    {
      path           = "${path.module}/../fixtures/python-app-poetry"
      poetry_install = true
      poetry_tmp_dir = "${path.cwd}/../fixtures"
    }
  ]
  hash_extra = "extra-hash-to-prevent-conflicts-with-module.package_dir"

  build_in_docker = true
  runtime         = "python3.12"
  docker_image    = "build-python-poetry"
  docker_file     = "${path.module}/../fixtures/python-app-poetry/docker/Dockerfile"
  artifacts_dir   = "${path.root}/builds/lambda_layer_poetry/"
}

#######################
# Deploy from packaged
#######################

module "lambda_function_from_package" {
  source = "../../"

  create_package         = false
  local_existing_package = module.package_with_commands_and_patterns.local_filename

  function_name = "${random_pet.this.id}-function-packaged"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"

  layers = [
    module.lambda_layer.lambda_layer_arn
  ]
}

################################################
# Layer that supports requirements.txt install #
###############################################
module "lambda_layer_pip_requirements" {
  source = "../.."

  create_function = false
  create_layer    = true

  layer_name          = "${random_pet.this.id}-layer-pip-requirements"
  compatible_runtimes = ["python3.12"]
  runtime             = "python3.12" # required to force layers to do pip install

  source_path = [
    {
      path             = "${path.module}/../fixtures/python-app1"
      pip_requirements = true
      prefix_in_zip    = "python" # required to get the path correct
    }
  ]
}
