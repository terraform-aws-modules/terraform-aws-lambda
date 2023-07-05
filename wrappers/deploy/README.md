# Wrapper for module: `modules/deploy`

The configuration in this directory contains an implementation of a single module wrapper pattern, which allows managing several copies of a module in places where using the native Terraform 0.13+ `for_each` feature is not feasible (e.g., with Terragrunt).

You may want to use a single Terragrunt configuration file to manage multiple resources without duplicating `terragrunt.hcl` files for each copy of the same module.

This wrapper does not implement any extra functionality.

## Usage with Terragrunt

`terragrunt.hcl`:

```hcl
terraform {
  source = "tfr:///terraform-aws-modules/lambda/aws//wrappers/deploy"
  # Alternative source:
  # source = "git::git@github.com:terraform-aws-modules/terraform-aws-lambda.git//wrappers/deploy?ref=master"
}

inputs = {
  defaults = { # Default values
    create_app = true
    tags = {
      Terraform   = "true"
      Environment = "dev"
    }
  }

  items = {
    my-item = {
      # omitted... can be any argument supported by the module
    }
    my-second-item = {
      # omitted... can be any argument supported by the module
    }
    # omitted...
  }
}
```

## Usage with Terraform

```hcl
module "wrapper" {
  source = "terraform-aws-modules/lambda/aws//wrappers/deploy"

  defaults = { # Default values
    create_app = true
    tags = {
      Terraform   = "true"
      Environment = "dev"
    }
  }

  items = {
    my-item = {
      # omitted... can be any argument supported by the module
    }
    my-second-item = {
      # omitted... can be any argument supported by the module
    }
    # omitted...
  }
}
```

## Example: Manage multiple deployment via AWS CodeDeploy in one Terragrunt layer

`eu-west-1/lambda-deploys/terragrunt.hcl`:

```hcl
terraform {
  source = "tfr:///terraform-aws-modules/lambda/aws//wrappers/deploy"
  # Alternative source:
  # source = "git::git@github.com:terraform-aws-modules/terraform-aws-lambda.git//wrappers/deploy?ref=master"
}

dependency "aliases" {
  config_path = "../lambdas-aliases/"
}
dependency "lambda1" {
  config_path = "../lambdas/lambda1"
}
dependency "lambda2" {
  config_path = "../lambdas/lambda2"
}

inputs = {
  defaults = {
    create_app                 = true
    reate_deployment_group     = true
    create_deployment          = true
    run_deployment             = true
    wait_deployment_completion = true

    triggers = {
      start = {
        events     = ["DeploymentStart"]
        name       = "DeploymentStart"
        target_arn = "arn:aws:sns:eu-west-1:135367859851:sns1"
      }
      success = {
        events     = ["DeploymentSuccess"]
        name       = "DeploymentSuccess"
        target_arn = "arn:aws:sns:eu-west-1:135367859851:sns2"
      }
    }

    tags = {
      Terraform   = "true"
      Environment = "dev"
    }
  }

  items = {
    deploy1 = {
      app_name                = "my-random-app-1"
      deployment_group_name   = "something1"

      alias_name     = dependency.aliases.outputs.wrapper.alias1.lambda_alias_name
      function_name  = dependency.lambda1.outputs.lambda_function_name
      target_version = dependency.lambda1.outputs.lambda_function_version
    }
    deploy2 = {
      app_name                = "my-random-app-2"
      deployment_group_name   = "something2"

      alias_name     = dependency.aliases.outputs.wrapper.alias2.lambda_alias_name
      function_name  = dependency.lambda2.outputs.lambda_function_name
      target_version = dependency.lambda2.outputs.lambda_function_version
    }
  }
}
```
