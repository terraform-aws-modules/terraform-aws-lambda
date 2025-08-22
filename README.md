# AWS Lambda Terraform module

Terraform module, which creates almost all supported AWS Lambda resources as well as taking care of building and packaging of required Lambda dependencies for functions and layers.

[![SWUbanner](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)

This Terraform module is the part of [serverless.tf framework](https://github.com/antonbabenko/serverless.tf), which aims to simplify all operations when working with the serverless in Terraform:

1. Build and install dependencies - [read more](#build). Requires Python 3.6 or newer.
2. Create, store, and use deployment packages - [read more](#package).
3. Create, update, and publish AWS Lambda Function and Lambda Layer - [see usage](#usage).
4. Create static and dynamic aliases for AWS Lambda Function - [see usage](#usage), see [modules/alias](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/modules/alias).
5. Do complex deployments (eg, rolling, canary, rollbacks, triggers) - [read more](#deployment), see [modules/deploy](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/modules/deploy).
6. Use AWS SAM CLI to test Lambda Function - [read more](#sam_cli_integration).

## Features

- Build dependencies for your Lambda Function and Layer.
- Support builds locally and in Docker (with or without SSH agent support for private builds) for any runtime and architecture supported by AWS Lambda.
- Create deployment package or deploy existing (previously built package) from local, from S3, from URL, or from AWS ECR repository.
- Store deployment packages locally or in the S3 bucket.
- Support almost all features of Lambda resources (function, layer, alias, etc.)
- Lambda@Edge
- Conditional creation for many types of resources.
- Control execution of nearly any step in the process - build, package, store package, deploy, update.
- Control nearly all aspects of Lambda resources (provisioned concurrency, VPC, EFS, dead-letter notification, tracing, async events, event source mapping, IAM role, IAM policies, and more).
- Support integration with other `serverless.tf` modules like [HTTP API Gateway](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2) (see [examples there](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/tree/master/examples/complete-http)).

## Usage

### Lambda Function (store package locally)

```hcl
module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "my-lambda1"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"

  source_path = "../src/lambda-function1"

  tags = {
    Name = "my-lambda1"
  }
}
```

### Lambda Function and Lambda Layer (store packages on S3)

```hcl
module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "lambda-with-layer"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"
  publish       = true

  source_path = "../src/lambda-function1"

  store_on_s3 = true
  s3_bucket   = "my-bucket-id-with-lambda-builds"

  layers = [
    module.lambda_layer_s3.lambda_layer_arn,
  ]

  environment_variables = {
    Serverless = "Terraform"
  }

  tags = {
    Module = "lambda-with-layer"
  }
}

module "lambda_layer_s3" {
  source = "terraform-aws-modules/lambda/aws"

  create_layer = true

  layer_name          = "lambda-layer-s3"
  description         = "My amazing lambda layer (deployed from S3)"
  compatible_runtimes = ["python3.12"]

  source_path = "../src/lambda-layer"

  store_on_s3 = true
  s3_bucket   = "my-bucket-id-with-lambda-builds"
}
```

### Lambda Functions with existing package (prebuilt) stored locally

```hcl
module "lambda_function_existing_package_local" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "my-lambda-existing-package-local"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"

  create_package         = false
  local_existing_package = "../existing_package.zip"
}
```

### Lambda Function or Lambda Layer with the deployable artifact maintained separately from the infrastructure

If you want to manage function code and infrastructure resources (such as IAM permissions, policies, events, etc) in separate flows (e.g., different repositories, teams, CI/CD pipelines).

Disable source code tracking to turn off deployments (and rollbacks) using the module by setting `ignore_source_code_hash = true` and deploy a _dummy function_.

When the infrastructure and the dummy function is deployed, you can use external tool to update the source code of the function (eg, using [AWS CLI](https://docs.aws.amazon.com/cli/latest/reference/lambda/update-function-code.html)) and keep using this module via Terraform to manage the infrastructure.

Be aware that changes in `local_existing_package` value may trigger deployment via Terraform.

```hcl
module "lambda_function_externally_managed_package" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "my-lambda-externally-managed-package"
  description   = "My lambda function code is deployed separately"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"

  create_package         = false
  local_existing_package = "./lambda_functions/code.zip"

  ignore_source_code_hash = true
}
```

### Lambda Function with existing package (prebuilt) stored in S3 bucket

Note that this module does not copy prebuilt packages into S3 bucket. This module can only store packages it builds locally and in S3 bucket.

```hcl
locals {
  my_function_source = "../path/to/package.zip"
}

resource "aws_s3_bucket" "builds" {
  bucket = "my-builds"
  acl    = "private"
}

resource "aws_s3_object" "my_function" {
  bucket = aws_s3_bucket.builds.id
  key    = "${filemd5(local.my_function_source)}.zip"
  source = local.my_function_source
}

module "lambda_function_existing_package_s3" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "my-lambda-existing-package-local"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"

  create_package      = false
  s3_existing_package = {
    bucket = aws_s3_bucket.builds.id
    key    = aws_s3_object.my_function.id
  }
}
```

### Lambda Functions from Container Image stored on AWS ECR

```hcl
module "lambda_function_container_image" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "my-lambda-existing-package-local"
  description   = "My awesome lambda function"

  create_package = false

  image_uri    = "132367819851.dkr.ecr.eu-west-1.amazonaws.com/complete-cow:1.0"
  package_type = "Image"
}
```

### Lambda Layers (store packages locally and on S3)

```hcl
module "lambda_layer_local" {
  source = "terraform-aws-modules/lambda/aws"

  create_layer = true

  layer_name          = "my-layer-local"
  description         = "My amazing lambda layer (deployed from local)"
  compatible_runtimes = ["python3.12"]

  source_path = "../fixtures/python-app1"
}

module "lambda_layer_s3" {
  source = "terraform-aws-modules/lambda/aws"

  create_layer = true

  layer_name          = "my-layer-s3"
  description         = "My amazing lambda layer (deployed from S3)"
  compatible_runtimes = ["python3.12"]

  source_path = "../fixtures/python-app1"

  store_on_s3 = true
  s3_bucket   = "my-bucket-id-with-lambda-builds"
}
```

### Lambda@Edge

Make sure, you deploy Lambda@Edge functions into US East (N. Virginia) region (`us-east-1`). See [Requirements and Restrictions on Lambda Functions](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-requirements-limits.html#lambda-requirements-cloudfront-triggers).

```hcl
module "lambda_at_edge" {
  source = "terraform-aws-modules/lambda/aws"

  lambda_at_edge = true

  function_name = "my-lambda-at-edge"
  description   = "My awesome lambda@edge function"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"

  source_path = "../fixtures/python-app1"

  tags = {
    Module = "lambda-at-edge"
  }
}
```

### Lambda Function in VPC

```hcl
module "lambda_function_in_vpc" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "my-lambda-in-vpc"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"

  source_path = "../fixtures/python-app1"

  vpc_subnet_ids         = module.vpc.intra_subnets
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  attach_network_policy = true
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.10.0.0/16"

  # Specify at least one of: intra_subnets, private_subnets, or public_subnets
  azs           = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  intra_subnets = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
}
```

## Additional IAM policies for Lambda Functions

There are 6 supported ways to attach IAM policies to IAM role used by Lambda Function:

1. `policy_json` - JSON string or heredoc, when `attach_policy_json = true`.
1. `policy_jsons` - List of JSON strings or heredoc, when `attach_policy_jsons = true` and `number_of_policy_jsons > 0`.
1. `policy` - ARN of existing IAM policy, when `attach_policy = true`.
1. `policies` - List of ARNs of existing IAM policies, when `attach_policies = true` and `number_of_policies > 0`.
1. `policy_statements` - Map of maps to define IAM statements which will be generated as IAM policy. Requires `attach_policy_statements = true`. See `examples/complete` for more information.
1. `assume_role_policy_statements` - Map of maps to define IAM statements which will be generated as IAM policy for assuming Lambda Function role (trust relationship). See `examples/complete` for more information.

## Lambda Permissions for allowed triggers

Lambda Permissions should be specified to allow certain resources to invoke Lambda Function.

```hcl
module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  # ...omitted for brevity

  allowed_triggers = {
    Config = {
      principal        = "config.amazonaws.com"
      principal_org_id = "o-abcdefghij"
    }
    APIGatewayAny = {
      service    = "apigateway"
      source_arn = "arn:aws:execute-api:eu-west-1:135367859851:aqnku8akd0/*/*/*"
    },
    APIGatewayDevPost = {
      service    = "apigateway"
      source_arn = "arn:aws:execute-api:eu-west-1:135367859851:aqnku8akd0/dev/POST/*"
    },
    OneRule = {
      principal  = "events.amazonaws.com"
      source_arn = "arn:aws:events:eu-west-1:135367859851:rule/RunDaily"
    }
  }
}
```

## Conditional creation

Sometimes you need to have a way to create resources conditionally but Terraform does not allow usage of `count` inside `module` block, so the solution is to specify `create` arguments.

```hcl
module "lambda" {
  source = "terraform-aws-modules/lambda/aws"

  create = false # to disable all resources

  create_package  = false  # to control build package process
  create_function = false  # to control creation of the Lambda Function and related resources
  create_layer    = false  # to control creation of the Lambda Layer and related resources
  create_role     = false  # to control creation of the IAM role and policies required for Lambda Function

  attach_cloudwatch_logs_policy = false
  attach_dead_letter_policy     = false
  attach_network_policy         = false
  attach_tracing_policy         = false
  attach_async_event_policy     = false

  # ... omitted
}
```

## <a name="build-package"></a> How does building and packaging work?

This is one of the most complicated part done by the module and normally you don't have to know internals.

`package.py` is Python script which does it. Make sure, Python 3.6 or newer is installed. The main functions of the script are to generate a filename of zip-archive based on the content of the files, verify if zip-archive has been already created, and create zip-archive only when it is necessary (during `apply`, not `plan`).

Hash of zip-archive created with the same content of the files is always identical which prevents unnecessary force-updates of the Lambda resources unless content modifies. If you need to have different filenames for the same content you can specify extra string argument `hash_extra`.

When calling this module multiple times in one execution to create packages with the same `source_path`, zip-archives will be corrupted due to concurrent writes into the same file. There are two solutions - set different values for `hash_extra` to create different archives, or create package once outside (using this module) and then pass `local_existing_package` argument to create other Lambda resources.

## <a name="debug"></a> Debug

Building and packaging has been historically hard to debug (especially with Terraform), so we made an effort to make it easier for user to see debug info. There are 3 different debug levels: `DEBUG` - to see only what is happening during planning phase and how a zip file content filtering in case of applied patterns, `DEBUG2` - to see more logging output, `DEBUG3` - to see all logging values, `DUMP_ENV` - to see all logging values and env variables (be careful sharing your env variables as they may contain secrets!).

User can specify debug level like this:

```
export TF_LAMBDA_PACKAGE_LOG_LEVEL=DEBUG2
terraform apply
```

User can enable comments in heredoc strings in `patterns` which can be helpful in some situations. To do this set this environment variable:

```
export TF_LAMBDA_PACKAGE_PATTERN_COMMENTS=true
terraform apply
```

## <a name="build"></a> Build Dependencies

You can specify `source_path` in a variety of ways to achieve desired flexibility when building deployment packages locally or in Docker. You can use absolute or relative paths. If you have placed terraform files in subdirectories, note that relative paths are specified from the directory where `terraform plan` is run and not the location of your terraform file.

Note that, when building locally, files are not copying anywhere from the source directories when making packages, we use fast Python regular expressions to find matching files and directories, which makes packaging very fast and easy to understand.

### Simple build from single directory

When `source_path` is set to a string, the content of that path will be used to create deployment package as-is:

`source_path = "src/function1"`

### Static build from multiple source directories

When `source_path` is set to a list of directories the content of each will be taken and one archive will be created.

### Combine various options for extreme flexibility

This is the most complete way of creating a deployment package from multiple sources with multiple dependencies. This example is showing some of the available options (see [examples/build-package](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/build-package) and [examples/runtimes](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/runtimes) for more):

```hcl
source_path = [
  "src/main-source",
  "src/another-source/index.py",
  {
    path     = "src/function1-dep",
    patterns = [
      "!.*/.*\\.txt", # Skip all txt files recursively
    ]
  }, {
    path             = "src/python-app1",
    pip_requirements = true,
    pip_tmp_dir      = "/tmp/dir/location"
    prefix_in_zip    = "foo/bar1",
  }, {
    path             = "src/python-app2",
    pip_requirements = "requirements-large.txt",
    patterns = [
      "!vendor/colorful-0.5.4.dist-info/RECORD",
      "!vendor/colorful-.+.dist-info/.*",
      "!vendor/colorful/__pycache__/?.*",
    ]
  }, {
    path             = "src/nodejs14.x-app1",
    npm_requirements = true,
    npm_tmp_dir      = "/tmp/dir/location"
    prefix_in_zip    = "foo/bar1",
  }, {
    path     = "src/python-app3",
    commands = [
      "npm install",
      ":zip"
    ],
    patterns = [
      "!.*/.*\\.txt",    # Skip all txt files recursively
      "node_modules/.+", # Include all node_modules
    ],
  }, {
    path     = "src/python-app3",
    commands = ["go build"],
    patterns = <<END
      bin/.*
      abc/def/.*
    END
  }
]
```

*Few notes:*

- If you specify a source path as a string that references a folder and the runtime begins with `python` or `nodejs`, the build process will automatically build python and nodejs dependencies if `requirements.txt` or `package.json` file will be found in the source folder. If you want to customize this behavior, please use the object notation as explained below.
- All arguments except `path` are optional.
- `patterns` - List of Python regex filenames should satisfy. Default value is "include everything" which is equal to `patterns = [".*"]`. This can also be specified as multiline heredoc string (no comments allowed). Some examples of valid patterns:
- If you use the `commands` option and chain multiple commands, only the exit code of last command will be checked for success. If you prefer to fail fast, start the commands with the bash option `set -e` or powershell option `$ErrorActionPreference="Stop"`

```txt
    !.*/.*\.txt        # Filter all txt files recursively
    node_modules/.*    # Include empty dir or with a content if it exists
    node_modules/.+    # Include full non empty node_modules dir with its content
    node_modules/      # Include node_modules itself without its content
                       # It's also a way to include an empty dir if it exists
    node_modules       # Include a file or an existing dir only

    !abc/.*            # Filter out everything in an abc folder
    abc/def/.*         # Re-include everything in abc/def sub folder
    !abc/def/hgk/.*    # Filter out again in abc/def/hgk sub folder
```

- `commands` - List of commands to run. If specified, this argument overrides `pip_requirements` and `npm_requirements`.
  - `:zip [source] [destination]` is a special command which creates content of current working directory (first argument) and places it inside of path (second argument).
- `pip_requirements` - Controls whether to execute `pip install`. Set to `false` to disable this feature, `true` to run `pip install` with `requirements.txt` found in `path`. Or set to another filename which you want to use instead. When `source_path` is passed as a string containing a path (and not a list of maps), and `requirements.txt` is present, `pip install` is automatically executed.
- `pip_tmp_dir` - Set the base directory to make the temporary directory for pip installs. Can be useful for Docker in Docker builds.
- `poetry_install` - Controls whether to execute `poetry export` and `pip install`. Set to `false` to disable this feature, `true` to run `poetry export` with `pyproject.toml` and `poetry.lock` found in `path`. When `source_path` is passed as a string containing a path (and not a list of maps), and `pyproject.toml` with a build system `poetry` is present, `poetry export` and `pip install` are automatically executed.
- `poetry_export_extra_args` - A list of additional poetry arguments to add to the poetry export command
- `npm_requirements` - Controls whether to execute `npm install`. Set to `false` to disable this feature, `true` to run `npm install` with `package.json` found in `path`. Or set to another filename which you want to use instead.
- `npm_tmp_dir` - Set the base directory to make the temporary directory for npm installs. Can be useful for Docker in Docker builds.
- `prefix_in_zip` - If specified, will be used as a prefix inside zip-archive. By default, everything installs into the root of zip-archive.

### Building in Docker

If your Lambda Function or Layer uses some dependencies you can build them in Docker and have them included into deployment package. Here is how you can do it:

    build_in_docker   = true
    docker_file       = "src/python-app1/docker/Dockerfile"
    docker_build_root = "src/python-app1/docker"
    docker_image      = "public.ecr.aws/sam/build-python"
    runtime           = "python3.12"    # Setting runtime is required when building package in Docker and Lambda Layer resource.

Using this module you can install dependencies from private hosts. To do this, you need for forward SSH agent:

    docker_with_ssh_agent = true

Note that by default, the `docker_image` used comes from the registry `public.ecr.aws/sam/`, and will be based on the `runtime` that you specify. In other words, if you specify a runtime of `python3.12` and do not specify `docker_image`, then the `docker_image` will resolve to `public.ecr.aws/sam/build-python3.12`. This ensures that by default the `runtime` is available in the docker container.

If you override `docker_image`, be sure to keep the image in sync with your `runtime`. During the plan phase, when using docker, there is no check that the `runtime` is available to build the package. That means that if you use an image that does not have the runtime, the plan will still succeed, but then the apply will fail.

#### Passing additional Docker options

To add flexibility when building in docker, you can pass any number of additional options that you require (see [Docker run reference](https://docs.docker.com/engine/reference/run/) for available options):

```hcl
  docker_additional_options = [
        "-e", "MY_ENV_VAR='My environment variable value'",
        "-v", "/local:/docker-vol",
  ]
```

#### Overriding Docker Entrypoint

To override the docker entrypoint when building in docker, set `docker_entrypoint`:

```hcl
  docker_entrypoint = "/entrypoint/entrypoint.sh"
```

The entrypoint must map to a path within your container, so you need to either build your own image that contains the entrypoint or map it to a file on the host by mounting a volume (see [Passing additional Docker options](#passing-additional-docker-options)).

## <a name="package"></a> Deployment package - Create or use existing

By default, this module creates deployment package and uses it to create or update Lambda Function or Lambda Layer.

Sometimes, you may want to separate build of deployment package (eg, to compile and install dependencies) from the deployment of a package into two separate steps.

When creating archive locally outside of this module you need to set `create_package = false` and then argument `local_existing_package = "existing_package.zip"`. Alternatively, you may prefer to keep your deployment packages into S3 bucket and provide a reference to them like this:

```hcl
  create_package      = false
  s3_existing_package = {
    bucket = "my-bucket-with-lambda-builds"
    key    = "existing_package.zip"
  }
```

### Using deployment package from remote URL

This can be implemented in two steps: download file locally using CURL, and pass path to deployment package as `local_existing_package` argument.

```hcl
locals {
  package_url = "https://raw.githubusercontent.com/terraform-aws-modules/terraform-aws-lambda/master/examples/fixtures/python-zip/existing_package.zip"
  downloaded  = "downloaded_package_${md5(local.package_url)}.zip"
}

resource "null_resource" "download_package" {
  triggers = {
    downloaded = local.downloaded
  }

  provisioner "local-exec" {
    command = "curl -L -o ${local.downloaded} ${local.package_url}"
  }
}

data "null_data_source" "downloaded_package" {
  inputs = {
    id       = null_resource.download_package.id
    filename = local.downloaded
  }
}

module "lambda_function_existing_package_from_remote_url" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "my-lambda-existing-package-local"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"

  create_package         = false
  local_existing_package = data.null_data_source.downloaded_package.outputs["filename"]
}
```

## <a name="sam_cli_integration"></a> How to use AWS SAM CLI to test Lambda Function?
[AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-command-reference.html) is an open source tool that help the developers to initiate, build, test, and deploy serverless
applications. SAM CLI tool [supports Terraform applications](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/what-is-terraform-support.html).

SAM CLI provides two ways of testing: local testing and testing on-cloud (Accelerate).

### Local Testing
Using SAM CLI, you can invoke the lambda functions defined in the terraform application locally using the [sam local invoke](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-cli-command-reference-sam-local-invoke.html)
command, providing the function terraform address, or function name, and to set the `hook-name` to `terraform` to tell SAM CLI that the underlying project is a terraform application.

You can execute the `sam local invoke` command from your terraform application root directory as following:
```
sam local invoke --hook-name terraform module.hello_world_function.aws_lambda_function.this[0]
```
You can also pass an event to your lambda function, or overwrite its environment variables. Check [here](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-using-invoke.html) for more information.

You can also invoke your lambda function in debugging mode, and step-through your lambda function source code locally in your preferred editor. Check [here](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-using-debugging.html) for more information.

### Testing on-cloud (Accelerate)
You can use AWS SAM CLI to quickly test your application on your AWS development account. Using SAM Accelerate, you will be able to develop your lambda functions locally,
and once you save your updates, SAM CLI will update your development account with the updated Lambda functions. So, you can test it on cloud, and if there is any bug,
you can quickly update the code, and SAM CLI will take care of pushing it to the cloud. Check [here](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/accelerate.html) for more information about SAM Accelerate.

You can execute the `sam sync` command from your terraform application root directory as following:
```
sam sync --hook-name terraform --watch
```

## <a name="deployment"></a> How to deploy and manage Lambda Functions?

### Simple deployments

Typically, Lambda Function resource updates when source code changes. If `publish = true` is specified a new [Lambda Function version](https://docs.aws.amazon.com/lambda/latest/dg/configuration-versions.html) will also be created.

Published Lambda Function can be invoked using either by version number or using `$LATEST`. This is the simplest way of deployment which does not required any additional tool or service.

### Controlled deployments (rolling, canary, rollbacks)

In order to do controlled deployments (rolling, canary, rollbacks) of Lambda Functions we need to use [Lambda Function aliases](https://docs.aws.amazon.com/lambda/latest/dg/configuration-aliases.html).

In simple terms, Lambda alias is like a pointer to either one version of Lambda Function (when deployment complete), or to two weighted versions of Lambda Function (during rolling or canary deployment).

One Lambda Function can be used in multiple aliases. Using aliases gives large control of which version deployed when having multiple environments.

There is [alias module](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/modules/alias), which simplifies working with alias (create, manage configurations, updates, etc). See [examples/alias](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/alias) for various use-cases how aliases can be configured and used.

There is [deploy module](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/modules/deploy), which creates required resources to do deployments using AWS CodeDeploy. It also creates the deployment, and wait for completion. See [examples/deploy](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/deploy) for complete end-to-end build/update/deploy process.

## <a name="terraform-cloud"></a> Terraform CI/CD

Terraform Cloud, Terraform Enterprise, and many other SaaS for running Terraform do not have Python pre-installed on the workers. You will need to provide an [alternative Docker image](https://www.terraform.io/docs/enterprise/install/installer.html#alternative-terraform-worker-image) with Python installed to be able to use this module there.

## FAQ

Q1: Why deployment package not recreating every time I change something? Or why deployment package is being recreated every time but content has not been changed?

> Answer: There can be several reasons related to concurrent executions, or to content hash. Sometimes, changes has happened inside of dependency which is not used in calculating content hash. Or multiple packages are creating at the same time from the same sources. You can force it by setting value of `hash_extra` to distinct values.

Q2: How to force recreate deployment package?

> Answer: Delete an existing zip-archive from `builds` directory, or make a change in your source code. If there is no zip-archive for the current content hash, it will be recreated during `terraform apply`.

Q3: `null_resource.archive[0] must be replaced`

> Answer: This probably mean that zip-archive has been deployed, but is currently absent locally, and it has to be recreated locally. When you run into this issue during CI/CD process (where workspace is clean) or from multiple workspaces, you can set environment variable `TF_RECREATE_MISSING_LAMBDA_PACKAGE=false` or pass `recreate_missing_package = false` as a parameter to the module and run `terraform apply`. Alternatively, you can pass `trigger_on_package_timestamp = false` as a parameter to ignore the file timestamp when deciding to create the archive or not.

Q4: What does this error mean - `"We currently do not support adding policies for $LATEST."` ?

> Answer: When the Lambda function is created with `publish = true` the new version is automatically increased and a qualified identifier (version number) becomes available and will be used when setting Lambda permissions.
>
> When `publish = false` (default), only unqualified identifier (`$LATEST`) is available which leads to the error.
>
> The solution is to either disable the creation of Lambda permissions for the current version by setting `create_current_version_allowed_triggers = false`, or to enable publish of Lambda function (`publish = true`).

## Notes

1. Creation of Lambda Functions and Lambda Layers is very similar and both support the same features (building from source path, using existing package, storing package locally or on S3)
2. Check out this [Awesome list of AWS Lambda Layers](https://github.com/mthenw/awesome-layers)

## Examples

- [Complete](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/complete) - Create Lambda resources in various combinations with all supported features.
- [Container Image](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/container-image) - Create a Docker image with a platform specified in the Dockerfile (using [docker provider](https://registry.terraform.io/providers/kreuzwerker/docker)), push it to AWS ECR, and create Lambda function from it.
- [Build and Package](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/build-package) - Build and create deployment packages in various ways.
- [Runtimes](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/build-package) - Build and create deployment packages for various runtimes (such as Rust, Go, Java).
- [Alias](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/alias) - Create static and dynamic aliases in various ways.
- [Deploy](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/deploy) - Complete end-to-end build/update/deploy process using AWS CodeDeploy.
- [Async Invocations](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/async) - Create Lambda Function with async event configuration (with SQS, SNS, and EventBridge integration).
- [With VPC](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/with-vpc) - Create Lambda Function with VPC.
- [With VPC and VPC Endpoint for S3](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/with-vpc-s3-endpoint) - Create Lambda Function with VPC and VPC Endpoint for S3.
- [With EFS](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/with-efs) - Create Lambda Function with Elastic File System attached (Terraform 0.13+ is recommended).
- [Multiple regions](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/multiple-regions) - Create the same Lambda Function in multiple regions with non-conflicting IAM roles and policies.
- [Event Source Mapping](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/event-source-mapping) - Create Lambda Function with event source mapping configuration (SQS, DynamoDB, Amazon MQ, and Kinesis).
- [Triggers](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/triggers) - Create Lambda Function with some triggers (eg, Cloudwatch Events, EventBridge).
- [Code Signing](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/code-signing) - Create Lambda Function with code signing configuration.
- [Simple CI/CD](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/simple-cicd) - Create Lambda Function as if it runs on CI/CD platform where `builds` directory is often absent.

# Examples by the users of this module

- [1Mill/serverless-tf-examples](https://github.com/1Mill/serverless-tf-examples/tree/main/src)


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |
| <a name="requirement_external"></a> [external](#requirement\_external) | >= 1.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 1.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.0 |
| <a name="provider_external"></a> [external](#provider\_external) | >= 1.0 |
| <a name="provider_local"></a> [local](#provider\_local) | >= 1.0 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.additional_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.additional_json](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.additional_jsons](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.async](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.dead_letter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.tracing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.additional_many](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.additional_one](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_event_source_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function_event_invoke_config.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_event_invoke_config) | resource |
| [aws_lambda_function_recursion_config.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_recursion_config) | resource |
| [aws_lambda_function_url.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_url) | resource |
| [aws_lambda_layer_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [aws_lambda_permission.current_version_triggers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.unqualified_alias_triggers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_provisioned_concurrency_config.current_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_provisioned_concurrency_config) | resource |
| [aws_s3_object.lambda_package](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [local_file.archive_plan](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.archive](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.sam_metadata_aws_lambda_function](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.sam_metadata_aws_lambda_layer_version](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_arn.log_group_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/arn) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_cloudwatch_log_group.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudwatch_log_group) | data source |
| [aws_iam_policy.tracing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.additional_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.async](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.dead_letter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [external_external.archive_prepare](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_triggers"></a> [allowed\_triggers](#input\_allowed\_triggers) | Map of allowed triggers to create Lambda permissions | `map(any)` | `{}` | no |
| <a name="input_architectures"></a> [architectures](#input\_architectures) | Instruction set architecture for your Lambda function. Valid values are ["x86\_64"] and ["arm64"]. | `list(string)` | `null` | no |
| <a name="input_artifacts_dir"></a> [artifacts\_dir](#input\_artifacts\_dir) | Directory name where artifacts should be stored | `string` | `"builds"` | no |
| <a name="input_assume_role_policy_statements"></a> [assume\_role\_policy\_statements](#input\_assume\_role\_policy\_statements) | Map of dynamic policy statements for assuming Lambda Function role (trust relationship) | `any` | `{}` | no |
| <a name="input_attach_async_event_policy"></a> [attach\_async\_event\_policy](#input\_attach\_async\_event\_policy) | Controls whether async event policy should be added to IAM role for Lambda Function | `bool` | `false` | no |
| <a name="input_attach_cloudwatch_logs_policy"></a> [attach\_cloudwatch\_logs\_policy](#input\_attach\_cloudwatch\_logs\_policy) | Controls whether CloudWatch Logs policy should be added to IAM role for Lambda Function | `bool` | `true` | no |
| <a name="input_attach_create_log_group_permission"></a> [attach\_create\_log\_group\_permission](#input\_attach\_create\_log\_group\_permission) | Controls whether to add the create log group permission to the CloudWatch logs policy | `bool` | `true` | no |
| <a name="input_attach_dead_letter_policy"></a> [attach\_dead\_letter\_policy](#input\_attach\_dead\_letter\_policy) | Controls whether SNS/SQS dead letter notification policy should be added to IAM role for Lambda Function | `bool` | `false` | no |
| <a name="input_attach_network_policy"></a> [attach\_network\_policy](#input\_attach\_network\_policy) | Controls whether VPC/network policy should be added to IAM role for Lambda Function | `bool` | `false` | no |
| <a name="input_attach_policies"></a> [attach\_policies](#input\_attach\_policies) | Controls whether list of policies should be added to IAM role for Lambda Function | `bool` | `false` | no |
| <a name="input_attach_policy"></a> [attach\_policy](#input\_attach\_policy) | Controls whether policy should be added to IAM role for Lambda Function | `bool` | `false` | no |
| <a name="input_attach_policy_json"></a> [attach\_policy\_json](#input\_attach\_policy\_json) | Controls whether policy\_json should be added to IAM role for Lambda Function | `bool` | `false` | no |
| <a name="input_attach_policy_jsons"></a> [attach\_policy\_jsons](#input\_attach\_policy\_jsons) | Controls whether policy\_jsons should be added to IAM role for Lambda Function | `bool` | `false` | no |
| <a name="input_attach_policy_statements"></a> [attach\_policy\_statements](#input\_attach\_policy\_statements) | Controls whether policy\_statements should be added to IAM role for Lambda Function | `bool` | `false` | no |
| <a name="input_attach_tracing_policy"></a> [attach\_tracing\_policy](#input\_attach\_tracing\_policy) | Controls whether X-Ray tracing policy should be added to IAM role for Lambda Function | `bool` | `false` | no |
| <a name="input_authorization_type"></a> [authorization\_type](#input\_authorization\_type) | The type of authentication that the Lambda Function URL uses. Set to 'AWS\_IAM' to restrict access to authenticated IAM users only. Set to 'NONE' to bypass IAM authentication and create a public endpoint. | `string` | `"NONE"` | no |
| <a name="input_build_in_docker"></a> [build\_in\_docker](#input\_build\_in\_docker) | Whether to build dependencies in Docker | `bool` | `false` | no |
| <a name="input_cloudwatch_logs_kms_key_id"></a> [cloudwatch\_logs\_kms\_key\_id](#input\_cloudwatch\_logs\_kms\_key\_id) | The ARN of the KMS Key to use when encrypting log data. | `string` | `null` | no |
| <a name="input_cloudwatch_logs_log_group_class"></a> [cloudwatch\_logs\_log\_group\_class](#input\_cloudwatch\_logs\_log\_group\_class) | Specified the log class of the log group. Possible values are: `STANDARD` or `INFREQUENT_ACCESS` | `string` | `null` | no |
| <a name="input_cloudwatch_logs_retention_in_days"></a> [cloudwatch\_logs\_retention\_in\_days](#input\_cloudwatch\_logs\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653. | `number` | `null` | no |
| <a name="input_cloudwatch_logs_skip_destroy"></a> [cloudwatch\_logs\_skip\_destroy](#input\_cloudwatch\_logs\_skip\_destroy) | Whether to keep the log group (and any logs it may contain) at destroy time. | `bool` | `false` | no |
| <a name="input_cloudwatch_logs_tags"></a> [cloudwatch\_logs\_tags](#input\_cloudwatch\_logs\_tags) | A map of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_code_signing_config_arn"></a> [code\_signing\_config\_arn](#input\_code\_signing\_config\_arn) | Amazon Resource Name (ARN) for a Code Signing Configuration | `string` | `null` | no |
| <a name="input_compatible_architectures"></a> [compatible\_architectures](#input\_compatible\_architectures) | A list of Architectures Lambda layer is compatible with. Currently x86\_64 and arm64 can be specified. | `list(string)` | `null` | no |
| <a name="input_compatible_runtimes"></a> [compatible\_runtimes](#input\_compatible\_runtimes) | A list of Runtimes this layer is compatible with. Up to 5 runtimes can be specified. | `list(string)` | `[]` | no |
| <a name="input_cors"></a> [cors](#input\_cors) | CORS settings to be used by the Lambda Function URL | `any` | `{}` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls whether resources should be created | `bool` | `true` | no |
| <a name="input_create_async_event_config"></a> [create\_async\_event\_config](#input\_create\_async\_event\_config) | Controls whether async event configuration for Lambda Function/Alias should be created | `bool` | `false` | no |
| <a name="input_create_current_version_allowed_triggers"></a> [create\_current\_version\_allowed\_triggers](#input\_create\_current\_version\_allowed\_triggers) | Whether to allow triggers on current version of Lambda Function (this will revoke permissions from previous version because Terraform manages only current resources) | `bool` | `true` | no |
| <a name="input_create_current_version_async_event_config"></a> [create\_current\_version\_async\_event\_config](#input\_create\_current\_version\_async\_event\_config) | Whether to allow async event configuration on current version of Lambda Function (this will revoke permissions from previous version because Terraform manages only current resources) | `bool` | `true` | no |
| <a name="input_create_function"></a> [create\_function](#input\_create\_function) | Controls whether Lambda Function resource should be created | `bool` | `true` | no |
| <a name="input_create_lambda_function_url"></a> [create\_lambda\_function\_url](#input\_create\_lambda\_function\_url) | Controls whether the Lambda Function URL resource should be created | `bool` | `false` | no |
| <a name="input_create_layer"></a> [create\_layer](#input\_create\_layer) | Controls whether Lambda Layer resource should be created | `bool` | `false` | no |
| <a name="input_create_package"></a> [create\_package](#input\_create\_package) | Controls whether Lambda package should be created | `bool` | `true` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Controls whether IAM role for Lambda Function should be created | `bool` | `true` | no |
| <a name="input_create_sam_metadata"></a> [create\_sam\_metadata](#input\_create\_sam\_metadata) | Controls whether the SAM metadata null resource should be created | `bool` | `false` | no |
| <a name="input_create_unqualified_alias_allowed_triggers"></a> [create\_unqualified\_alias\_allowed\_triggers](#input\_create\_unqualified\_alias\_allowed\_triggers) | Whether to allow triggers on unqualified alias pointing to $LATEST version | `bool` | `true` | no |
| <a name="input_create_unqualified_alias_async_event_config"></a> [create\_unqualified\_alias\_async\_event\_config](#input\_create\_unqualified\_alias\_async\_event\_config) | Whether to allow async event configuration on unqualified alias pointing to $LATEST version | `bool` | `true` | no |
| <a name="input_create_unqualified_alias_lambda_function_url"></a> [create\_unqualified\_alias\_lambda\_function\_url](#input\_create\_unqualified\_alias\_lambda\_function\_url) | Whether to use unqualified alias pointing to $LATEST version in Lambda Function URL | `bool` | `true` | no |
| <a name="input_dead_letter_target_arn"></a> [dead\_letter\_target\_arn](#input\_dead\_letter\_target\_arn) | The ARN of an SNS topic or SQS queue to notify when an invocation fails. | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of your Lambda Function (or Layer) | `string` | `""` | no |
| <a name="input_destination_on_failure"></a> [destination\_on\_failure](#input\_destination\_on\_failure) | Amazon Resource Name (ARN) of the destination resource for failed asynchronous invocations | `string` | `null` | no |
| <a name="input_destination_on_success"></a> [destination\_on\_success](#input\_destination\_on\_success) | Amazon Resource Name (ARN) of the destination resource for successful asynchronous invocations | `string` | `null` | no |
| <a name="input_docker_additional_options"></a> [docker\_additional\_options](#input\_docker\_additional\_options) | Additional options to pass to the docker run command (e.g. to set environment variables, volumes, etc.) | `list(string)` | `[]` | no |
| <a name="input_docker_build_root"></a> [docker\_build\_root](#input\_docker\_build\_root) | Root dir where to build in Docker | `string` | `""` | no |
| <a name="input_docker_entrypoint"></a> [docker\_entrypoint](#input\_docker\_entrypoint) | Path to the Docker entrypoint to use | `string` | `null` | no |
| <a name="input_docker_file"></a> [docker\_file](#input\_docker\_file) | Path to a Dockerfile when building in Docker | `string` | `""` | no |
| <a name="input_docker_image"></a> [docker\_image](#input\_docker\_image) | Docker image to use for the build | `string` | `""` | no |
| <a name="input_docker_pip_cache"></a> [docker\_pip\_cache](#input\_docker\_pip\_cache) | Whether to mount a shared pip cache folder into docker environment or not | `any` | `null` | no |
| <a name="input_docker_with_ssh_agent"></a> [docker\_with\_ssh\_agent](#input\_docker\_with\_ssh\_agent) | Whether to pass SSH\_AUTH\_SOCK into docker environment or not | `bool` | `false` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | A map that defines environment variables for the Lambda Function. | `map(string)` | `{}` | no |
| <a name="input_ephemeral_storage_size"></a> [ephemeral\_storage\_size](#input\_ephemeral\_storage\_size) | Amount of ephemeral storage (/tmp) in MB your Lambda Function can use at runtime. Valid value between 512 MB to 10,240 MB (10 GB). | `number` | `512` | no |
| <a name="input_event_source_mapping"></a> [event\_source\_mapping](#input\_event\_source\_mapping) | Map of event source mapping | `any` | `{}` | no |
| <a name="input_file_system_arn"></a> [file\_system\_arn](#input\_file\_system\_arn) | The Amazon Resource Name (ARN) of the Amazon EFS Access Point that provides access to the file system. | `string` | `null` | no |
| <a name="input_file_system_local_mount_path"></a> [file\_system\_local\_mount\_path](#input\_file\_system\_local\_mount\_path) | The path where the function can access the file system, starting with /mnt/. | `string` | `null` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | A unique name for your Lambda Function | `string` | `""` | no |
| <a name="input_function_tags"></a> [function\_tags](#input\_function\_tags) | A map of tags to assign only to the lambda function | `map(string)` | `{}` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | Lambda Function entrypoint in your code | `string` | `""` | no |
| <a name="input_hash_extra"></a> [hash\_extra](#input\_hash\_extra) | The string to add into hashing function. Useful when building same source path for different functions. | `string` | `""` | no |
| <a name="input_ignore_source_code_hash"></a> [ignore\_source\_code\_hash](#input\_ignore\_source\_code\_hash) | Whether to ignore changes to the function's source code hash. Set to true if you manage infrastructure and code deployments separately. | `bool` | `false` | no |
| <a name="input_image_config_command"></a> [image\_config\_command](#input\_image\_config\_command) | The CMD for the docker image | `list(string)` | `[]` | no |
| <a name="input_image_config_entry_point"></a> [image\_config\_entry\_point](#input\_image\_config\_entry\_point) | The ENTRYPOINT for the docker image | `list(string)` | `[]` | no |
| <a name="input_image_config_working_directory"></a> [image\_config\_working\_directory](#input\_image\_config\_working\_directory) | The working directory for the docker image | `string` | `null` | no |
| <a name="input_image_uri"></a> [image\_uri](#input\_image\_uri) | The ECR image URI containing the function's deployment package. | `string` | `null` | no |
| <a name="input_include_default_tag"></a> [include\_default\_tag](#input\_include\_default\_tag) | Set to false to not include the default tag in the tags map. | `bool` | `true` | no |
| <a name="input_invoke_mode"></a> [invoke\_mode](#input\_invoke\_mode) | Invoke mode of the Lambda Function URL. Valid values are BUFFERED (default) and RESPONSE\_STREAM. | `string` | `null` | no |
| <a name="input_ipv6_allowed_for_dual_stack"></a> [ipv6\_allowed\_for\_dual\_stack](#input\_ipv6\_allowed\_for\_dual\_stack) | Allows outbound IPv6 traffic on VPC functions that are connected to dual-stack subnets | `bool` | `null` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of KMS key to use by your Lambda Function | `string` | `null` | no |
| <a name="input_lambda_at_edge"></a> [lambda\_at\_edge](#input\_lambda\_at\_edge) | Set this to true if using Lambda@Edge, to enable publishing, limit the timeout, and allow edgelambda.amazonaws.com to invoke the function | `bool` | `false` | no |
| <a name="input_lambda_at_edge_logs_all_regions"></a> [lambda\_at\_edge\_logs\_all\_regions](#input\_lambda\_at\_edge\_logs\_all\_regions) | Whether to specify a wildcard in IAM policy used by Lambda@Edge to allow logging in all regions | `bool` | `true` | no |
| <a name="input_lambda_role"></a> [lambda\_role](#input\_lambda\_role) | IAM role ARN attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to. See Lambda Permission Model for more details. | `string` | `""` | no |
| <a name="input_layer_name"></a> [layer\_name](#input\_layer\_name) | Name of Lambda Layer to create | `string` | `""` | no |
| <a name="input_layer_skip_destroy"></a> [layer\_skip\_destroy](#input\_layer\_skip\_destroy) | Whether to retain the old version of a previously deployed Lambda Layer. | `bool` | `false` | no |
| <a name="input_layers"></a> [layers](#input\_layers) | List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function. | `list(string)` | `null` | no |
| <a name="input_license_info"></a> [license\_info](#input\_license\_info) | License info for your Lambda Layer. Eg, MIT or full url of a license. | `string` | `""` | no |
| <a name="input_local_existing_package"></a> [local\_existing\_package](#input\_local\_existing\_package) | The absolute path to an existing zip-file to use | `string` | `null` | no |
| <a name="input_logging_application_log_level"></a> [logging\_application\_log\_level](#input\_logging\_application\_log\_level) | The application log level of the Lambda Function. Valid values are "TRACE", "DEBUG", "INFO", "WARN", "ERROR", or "FATAL". | `string` | `"INFO"` | no |
| <a name="input_logging_log_format"></a> [logging\_log\_format](#input\_logging\_log\_format) | The log format of the Lambda Function. Valid values are "JSON" or "Text". | `string` | `"Text"` | no |
| <a name="input_logging_log_group"></a> [logging\_log\_group](#input\_logging\_log\_group) | The CloudWatch log group to send logs to. | `string` | `null` | no |
| <a name="input_logging_system_log_level"></a> [logging\_system\_log\_level](#input\_logging\_system\_log\_level) | The system log level of the Lambda Function. Valid values are "DEBUG", "INFO", or "WARN". | `string` | `"INFO"` | no |
| <a name="input_maximum_event_age_in_seconds"></a> [maximum\_event\_age\_in\_seconds](#input\_maximum\_event\_age\_in\_seconds) | Maximum age of a request that Lambda sends to a function for processing in seconds. Valid values between 60 and 21600. | `number` | `null` | no |
| <a name="input_maximum_retry_attempts"></a> [maximum\_retry\_attempts](#input\_maximum\_retry\_attempts) | Maximum number of times to retry when the function returns an error. Valid values between 0 and 2. Defaults to 2. | `number` | `null` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB your Lambda Function can use at runtime. Valid value between 128 MB to 10,240 MB (10 GB), in 64 MB increments. | `number` | `128` | no |
| <a name="input_number_of_policies"></a> [number\_of\_policies](#input\_number\_of\_policies) | Number of policies to attach to IAM role for Lambda Function | `number` | `0` | no |
| <a name="input_number_of_policy_jsons"></a> [number\_of\_policy\_jsons](#input\_number\_of\_policy\_jsons) | Number of policies JSON to attach to IAM role for Lambda Function | `number` | `0` | no |
| <a name="input_package_type"></a> [package\_type](#input\_package\_type) | The Lambda deployment package type. Valid options: Zip or Image | `string` | `"Zip"` | no |
| <a name="input_policies"></a> [policies](#input\_policies) | List of policy statements ARN to attach to Lambda Function role | `list(string)` | `[]` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | An additional policy document ARN to attach to the Lambda Function role | `string` | `null` | no |
| <a name="input_policy_json"></a> [policy\_json](#input\_policy\_json) | An additional policy document as JSON to attach to the Lambda Function role | `string` | `null` | no |
| <a name="input_policy_jsons"></a> [policy\_jsons](#input\_policy\_jsons) | List of additional policy documents as JSON to attach to Lambda Function role | `list(string)` | `[]` | no |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | IAM policy name. It override the default value, which is the same as role\_name | `string` | `null` | no |
| <a name="input_policy_statements"></a> [policy\_statements](#input\_policy\_statements) | Map of dynamic policy statements to attach to Lambda Function role | `any` | `{}` | no |
| <a name="input_provisioned_concurrent_executions"></a> [provisioned\_concurrent\_executions](#input\_provisioned\_concurrent\_executions) | Amount of capacity to allocate. Set to 1 or greater to enable, or set to 0 to disable provisioned concurrency. | `number` | `-1` | no |
| <a name="input_publish"></a> [publish](#input\_publish) | Whether to publish creation/change as new Lambda Function Version. | `bool` | `false` | no |
| <a name="input_putin_khuylo"></a> [putin\_khuylo](#input\_putin\_khuylo) | Do you agree that Putin doesn't respect Ukrainian sovereignty and territorial integrity? More info: https://en.wikipedia.org/wiki/Putin_khuylo! | `bool` | `true` | no |
| <a name="input_quiet_archive_local_exec"></a> [quiet\_archive\_local\_exec](#input\_quiet\_archive\_local\_exec) | Whether to disable archive local execution output | `bool` | `true` | no |
| <a name="input_recreate_missing_package"></a> [recreate\_missing\_package](#input\_recreate\_missing\_package) | Whether to recreate missing Lambda package if it is missing locally or not | `bool` | `true` | no |
| <a name="input_recursive_loop"></a> [recursive\_loop](#input\_recursive\_loop) | Lambda function recursion configuration. Valid values are Allow or Terminate. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where the resource(s) will be managed. Defaults to the region set in the provider configuration | `string` | `null` | no |
| <a name="input_replace_security_groups_on_destroy"></a> [replace\_security\_groups\_on\_destroy](#input\_replace\_security\_groups\_on\_destroy) | (Optional) When true, all security groups defined in vpc\_security\_group\_ids will be replaced with the default security group after the function is destroyed. Set the replacement\_security\_group\_ids variable to use a custom list of security groups for replacement instead. | `bool` | `null` | no |
| <a name="input_replacement_security_group_ids"></a> [replacement\_security\_group\_ids](#input\_replacement\_security\_group\_ids) | (Optional) List of security group IDs to assign to orphaned Lambda function network interfaces upon destruction. replace\_security\_groups\_on\_destroy must be set to true to use this attribute. | `list(string)` | `null` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | The amount of reserved concurrent executions for this Lambda Function. A value of 0 disables Lambda Function from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits -1. | `number` | `-1` | no |
| <a name="input_role_description"></a> [role\_description](#input\_role\_description) | Description of IAM role to use for Lambda Function | `string` | `null` | no |
| <a name="input_role_force_detach_policies"></a> [role\_force\_detach\_policies](#input\_role\_force\_detach\_policies) | Specifies to force detaching any policies the IAM role has before destroying it. | `bool` | `true` | no |
| <a name="input_role_maximum_session_duration"></a> [role\_maximum\_session\_duration](#input\_role\_maximum\_session\_duration) | Maximum session duration, in seconds, for the IAM role | `number` | `3600` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of IAM role to use for Lambda Function | `string` | `null` | no |
| <a name="input_role_path"></a> [role\_path](#input\_role\_path) | Path of IAM role to use for Lambda Function | `string` | `null` | no |
| <a name="input_role_permissions_boundary"></a> [role\_permissions\_boundary](#input\_role\_permissions\_boundary) | The ARN of the policy that is used to set the permissions boundary for the IAM role used by Lambda Function | `string` | `null` | no |
| <a name="input_role_tags"></a> [role\_tags](#input\_role\_tags) | A map of tags to assign to IAM role | `map(string)` | `{}` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Lambda Function runtime | `string` | `""` | no |
| <a name="input_s3_acl"></a> [s3\_acl](#input\_s3\_acl) | The canned ACL to apply. Valid values are private, public-read, public-read-write, aws-exec-read, authenticated-read, bucket-owner-read, and bucket-owner-full-control. Defaults to private. | `string` | `"private"` | no |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | S3 bucket to store artifacts | `string` | `null` | no |
| <a name="input_s3_existing_package"></a> [s3\_existing\_package](#input\_s3\_existing\_package) | The S3 bucket object with keys bucket, key, version pointing to an existing zip-file to use | `map(string)` | `null` | no |
| <a name="input_s3_kms_key_id"></a> [s3\_kms\_key\_id](#input\_s3\_kms\_key\_id) | Specifies a custom KMS key to use for S3 object encryption. | `string` | `null` | no |
| <a name="input_s3_object_override_default_tags"></a> [s3\_object\_override\_default\_tags](#input\_s3\_object\_override\_default\_tags) | Whether to override the default\_tags from provider? NB: S3 objects support a maximum of 10 tags. | `bool` | `false` | no |
| <a name="input_s3_object_storage_class"></a> [s3\_object\_storage\_class](#input\_s3\_object\_storage\_class) | Specifies the desired Storage Class for the artifact uploaded to S3. Can be either STANDARD, REDUCED\_REDUNDANCY, ONEZONE\_IA, INTELLIGENT\_TIERING, or STANDARD\_IA. | `string` | `"ONEZONE_IA"` | no |
| <a name="input_s3_object_tags"></a> [s3\_object\_tags](#input\_s3\_object\_tags) | A map of tags to assign to S3 bucket object. | `map(string)` | `{}` | no |
| <a name="input_s3_object_tags_only"></a> [s3\_object\_tags\_only](#input\_s3\_object\_tags\_only) | Set to true to not merge tags with s3\_object\_tags. Useful to avoid breaching S3 Object 10 tag limit. | `bool` | `false` | no |
| <a name="input_s3_prefix"></a> [s3\_prefix](#input\_s3\_prefix) | Directory name where artifacts should be stored in the S3 bucket. If unset, the path from `artifacts_dir` is used | `string` | `null` | no |
| <a name="input_s3_server_side_encryption"></a> [s3\_server\_side\_encryption](#input\_s3\_server\_side\_encryption) | Specifies server-side encryption of the object in S3. Valid values are "AES256" and "aws:kms". | `string` | `null` | no |
| <a name="input_skip_destroy"></a> [skip\_destroy](#input\_skip\_destroy) | Set to true if you do not wish the function to be deleted at destroy time, and instead just remove the function from the Terraform state. Useful for Lambda@Edge functions attached to CloudFront distributions. | `bool` | `null` | no |
| <a name="input_snap_start"></a> [snap\_start](#input\_snap\_start) | (Optional) Snap start settings for low-latency startups | `bool` | `false` | no |
| <a name="input_source_path"></a> [source\_path](#input\_source\_path) | The absolute path to a local file or directory containing your Lambda source code | `any` | `null` | no |
| <a name="input_store_on_s3"></a> [store\_on\_s3](#input\_store\_on\_s3) | Whether to store produced artifacts on S3 or locally. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to resources. | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The amount of time your Lambda Function has to run in seconds. | `number` | `3` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Define maximum timeout for creating, updating, and deleting Lambda Function resources | `map(string)` | `{}` | no |
| <a name="input_tracing_mode"></a> [tracing\_mode](#input\_tracing\_mode) | Tracing mode of the Lambda Function. Valid value can be either PassThrough or Active. | `string` | `null` | no |
| <a name="input_trigger_on_package_timestamp"></a> [trigger\_on\_package\_timestamp](#input\_trigger\_on\_package\_timestamp) | Whether to recreate the Lambda package if the timestamp changes | `bool` | `true` | no |
| <a name="input_trusted_entities"></a> [trusted\_entities](#input\_trusted\_entities) | List of additional trusted entities for assuming Lambda Function role (trust relationship) | `any` | `[]` | no |
| <a name="input_use_existing_cloudwatch_log_group"></a> [use\_existing\_cloudwatch\_log\_group](#input\_use\_existing\_cloudwatch\_log\_group) | Whether to use an existing CloudWatch log group or create new | `bool` | `false` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | List of security group ids when Lambda Function should run in the VPC. | `list(string)` | `null` | no |
| <a name="input_vpc_subnet_ids"></a> [vpc\_subnet\_ids](#input\_vpc\_subnet\_ids) | List of subnet ids when Lambda Function should run in the VPC. Usually private or intra subnets. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_cloudwatch_log_group_arn"></a> [lambda\_cloudwatch\_log\_group\_arn](#output\_lambda\_cloudwatch\_log\_group\_arn) | The ARN of the Cloudwatch Log Group |
| <a name="output_lambda_cloudwatch_log_group_name"></a> [lambda\_cloudwatch\_log\_group\_name](#output\_lambda\_cloudwatch\_log\_group\_name) | The name of the Cloudwatch Log Group |
| <a name="output_lambda_event_source_mapping_arn"></a> [lambda\_event\_source\_mapping\_arn](#output\_lambda\_event\_source\_mapping\_arn) | The event source mapping ARN |
| <a name="output_lambda_event_source_mapping_function_arn"></a> [lambda\_event\_source\_mapping\_function\_arn](#output\_lambda\_event\_source\_mapping\_function\_arn) | The the ARN of the Lambda function the event source mapping is sending events to |
| <a name="output_lambda_event_source_mapping_state"></a> [lambda\_event\_source\_mapping\_state](#output\_lambda\_event\_source\_mapping\_state) | The state of the event source mapping |
| <a name="output_lambda_event_source_mapping_state_transition_reason"></a> [lambda\_event\_source\_mapping\_state\_transition\_reason](#output\_lambda\_event\_source\_mapping\_state\_transition\_reason) | The reason the event source mapping is in its current state |
| <a name="output_lambda_event_source_mapping_uuid"></a> [lambda\_event\_source\_mapping\_uuid](#output\_lambda\_event\_source\_mapping\_uuid) | The UUID of the created event source mapping |
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | The ARN of the Lambda Function |
| <a name="output_lambda_function_arn_static"></a> [lambda\_function\_arn\_static](#output\_lambda\_function\_arn\_static) | The static ARN of the Lambda Function. Use this to avoid cycle errors between resources (e.g., Step Functions) |
| <a name="output_lambda_function_invoke_arn"></a> [lambda\_function\_invoke\_arn](#output\_lambda\_function\_invoke\_arn) | The Invoke ARN of the Lambda Function |
| <a name="output_lambda_function_kms_key_arn"></a> [lambda\_function\_kms\_key\_arn](#output\_lambda\_function\_kms\_key\_arn) | The ARN for the KMS encryption key of Lambda Function |
| <a name="output_lambda_function_last_modified"></a> [lambda\_function\_last\_modified](#output\_lambda\_function\_last\_modified) | The date Lambda Function resource was last modified |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | The name of the Lambda Function |
| <a name="output_lambda_function_qualified_arn"></a> [lambda\_function\_qualified\_arn](#output\_lambda\_function\_qualified\_arn) | The ARN identifying your Lambda Function Version |
| <a name="output_lambda_function_qualified_invoke_arn"></a> [lambda\_function\_qualified\_invoke\_arn](#output\_lambda\_function\_qualified\_invoke\_arn) | The Invoke ARN identifying your Lambda Function Version |
| <a name="output_lambda_function_signing_job_arn"></a> [lambda\_function\_signing\_job\_arn](#output\_lambda\_function\_signing\_job\_arn) | ARN of the signing job |
| <a name="output_lambda_function_signing_profile_version_arn"></a> [lambda\_function\_signing\_profile\_version\_arn](#output\_lambda\_function\_signing\_profile\_version\_arn) | ARN of the signing profile version |
| <a name="output_lambda_function_source_code_hash"></a> [lambda\_function\_source\_code\_hash](#output\_lambda\_function\_source\_code\_hash) | Base64-encoded representation of raw SHA-256 sum of the zip file |
| <a name="output_lambda_function_source_code_size"></a> [lambda\_function\_source\_code\_size](#output\_lambda\_function\_source\_code\_size) | The size in bytes of the function .zip file |
| <a name="output_lambda_function_url"></a> [lambda\_function\_url](#output\_lambda\_function\_url) | The URL of the Lambda Function URL |
| <a name="output_lambda_function_url_id"></a> [lambda\_function\_url\_id](#output\_lambda\_function\_url\_id) | The Lambda Function URL generated id |
| <a name="output_lambda_function_version"></a> [lambda\_function\_version](#output\_lambda\_function\_version) | Latest published version of Lambda Function |
| <a name="output_lambda_layer_arn"></a> [lambda\_layer\_arn](#output\_lambda\_layer\_arn) | The ARN of the Lambda Layer with version |
| <a name="output_lambda_layer_created_date"></a> [lambda\_layer\_created\_date](#output\_lambda\_layer\_created\_date) | The date Lambda Layer resource was created |
| <a name="output_lambda_layer_layer_arn"></a> [lambda\_layer\_layer\_arn](#output\_lambda\_layer\_layer\_arn) | The ARN of the Lambda Layer without version |
| <a name="output_lambda_layer_source_code_size"></a> [lambda\_layer\_source\_code\_size](#output\_lambda\_layer\_source\_code\_size) | The size in bytes of the Lambda Layer .zip file |
| <a name="output_lambda_layer_version"></a> [lambda\_layer\_version](#output\_lambda\_layer\_version) | The Lambda Layer version |
| <a name="output_lambda_role_arn"></a> [lambda\_role\_arn](#output\_lambda\_role\_arn) | The ARN of the IAM role created for the Lambda Function |
| <a name="output_lambda_role_name"></a> [lambda\_role\_name](#output\_lambda\_role\_name) | The name of the IAM role created for the Lambda Function |
| <a name="output_lambda_role_unique_id"></a> [lambda\_role\_unique\_id](#output\_lambda\_role\_unique\_id) | The unique id of the IAM role created for the Lambda Function |
| <a name="output_local_filename"></a> [local\_filename](#output\_local\_filename) | The filename of zip archive deployed (if deployment was from local) |
| <a name="output_s3_object"></a> [s3\_object](#output\_s3\_object) | The map with S3 object data of zip archive deployed (if deployment was from S3) |
<!-- END_TF_DOCS -->

## Development

### Python

During development involving modifying python files, use tox to run unit tests:

```
tox
```

This will try to run unit tests which each supported python version, reporting errors for python versions which are not installed locally.

If you only want to test against your main python version:

```
tox -e py
```

You can also pass additional positional arguments to pytest which is used to run test, e.g. to make it verbose:
```
tox -e py -- -vvv
```

## Authors

Module managed by [Anton Babenko](https://github.com/antonbabenko). Check out [serverless.tf](https://serverless.tf) to learn more about doing serverless with Terraform.

Please reach out to [Betajob](https://www.betajob.com/) if you are looking for commercial support for your Terraform, AWS, or serverless project.

## License

Apache 2 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/LICENSE) for full details.

## Additional information for users from Russia and Belarus

* Russia has [illegally annexed Crimea in 2014](https://en.wikipedia.org/wiki/Annexation_of_Crimea_by_the_Russian_Federation) and [brought the war in Donbas](https://en.wikipedia.org/wiki/War_in_Donbas) followed by [full-scale invasion of Ukraine in 2022](https://en.wikipedia.org/wiki/2022_Russian_invasion_of_Ukraine).
* Russia has brought sorrow and devastations to millions of Ukrainians, killed hundreds of innocent people, damaged thousands of buildings, and forced several million people to flee.
* [Putin khuylo!](https://en.wikipedia.org/wiki/Putin_khuylo!)
