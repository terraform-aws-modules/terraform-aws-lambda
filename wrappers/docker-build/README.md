# Wrapper for module: `modules/docker-build`

The configuration in this directory contains an implementation of a single module wrapper pattern, which allows managing several copies of a module in places where using the native Terraform 0.13+ `for_each` feature is not feasible (e.g., with Terragrunt).

You may want to use a single Terragrunt configuration file to manage multiple resources without duplicating `terragrunt.hcl` files for each copy of the same module.

This wrapper does not implement any extra functionality.

## Usage with Terragrunt

`terragrunt.hcl`:

```hcl
terraform {
  source = "tfr:///terraform-aws-modules/lambda/aws//wrappers/docker-build"
  # Alternative source:
  # source = "git::git@github.com:terraform-aws-modules/terraform-aws-lambda.git//wrappers/docker-build?ref=master"
}

inputs = {
  defaults = { # Default values
    create_ecr_repo = true
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
  source = "terraform-aws-modules/lambda/aws//wrappers/docker-build"

  defaults = { # Default values
    create_ecr_repo = true
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

## Example: Manage multiple Docker Container Image in one Terragrunt layer

`eu-west-1/docker-builds/terragrunt.hcl`:

```hcl
terraform {
  source = "tfr:///terraform-aws-modules/lambda/aws//wrappers"
  # Alternative source:
  # source = "git::git@github.com:terraform-aws-modules/terraform-aws-lambda.git//wrappers?ref=master"
}

# Generate an Docker provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "docker" {
  registry_auth {
    address  = "835367859852.dkr.ecr.eu-west-1.amazonaws.com"
    username = "awesome-user"
    password = "awesome-pwd"
  }
}
EOF
}

inputs = {
  defaults = {
    create_ecr_repo = true
    build_args      = {
      ENV = "dev"
    }
  }

  items = {
    docker-image1 = {
      ecr_repo     = "my-random-ecr-repo-1"
      image_tag    = "1.0"
      source_path  = "context1"
    }
    docker-image2 = {
      ecr_repo     = "my-random-ecr-repo-2"
      image_tag    = "1.0"
      source_path  = "context2"
      build_args      = {
        ENV = "qa"
      }
    }
  }
}
```
