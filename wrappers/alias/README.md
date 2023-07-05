# Wrapper for module: `modules/alias`

The configuration in this directory contains an implementation of a single module wrapper pattern, which allows managing several copies of a module in places where using the native Terraform 0.13+ `for_each` feature is not feasible (e.g., with Terragrunt).

You may want to use a single Terragrunt configuration file to manage multiple resources without duplicating `terragrunt.hcl` files for each copy of the same module.

This wrapper does not implement any extra functionality.

## Usage with Terragrunt

`terragrunt.hcl`:

```hcl
terraform {
  source = "tfr:///terraform-aws-modules/lambda/aws"
  # Alternative source:
  # source = "git::git@github.com:terraform-aws-modules/terraform-aws-lambda.git//wrappers/alias?ref=master"
}

inputs = {
  defaults = { # Default values
    create        = true
    refresh_alias = true
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
  source = "terraform-aws-modules/lambda/aws//wrappers/alias"

  defaults = { # Default values
    create        = true
    refresh_alias = true
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

## Example: Manage multiple aliases in one Terragrunt layer

`eu-west-1/lambda-aliases/terragrunt.hcl`:

```hcl
terraform {
  source = "tfr:///terraform-aws-modules/lambda/aws//wrappers/alias"
  # Alternative source:
  # source = "git::git@github.com:terraform-aws-modules/terraform-aws-lambda.git//wrappers/alias?ref=master"
}

dependency "lambda1" {
  config_path = "../lambdas/lambda1"
}
dependency "lambda2" {
  config_path = "../lambdas/lambda2"
}

inputs = {
  defaults = {
    refresh_alias = true
    allowed_triggers = {
      AnotherAPIGatewayAny = {
        service    = "apigateway"
        source_arn = "arn:aws:execute-api:eu-west-1:135367859851:abcdedfgse/*/*/*"
      }
    }
  }

  items = {
    alias1 = {
      name             = "my-random-alias-1"
      function_name    = dependency.lambda1.outputs.lambda_function_name
      function_version = dependency.lambda1.outputs.lambda_function_version
    }
    alias2 = {
      name             = "my-random-alias-2"
      function_name    = dependency.lambda2.outputs.lambda_function_name
      function_version = dependency.lambda2.outputs.lambda_function_version
    }
  }
}
```
