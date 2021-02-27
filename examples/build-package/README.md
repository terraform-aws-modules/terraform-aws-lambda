# Build Package Examples

Configuration in this directory creates deployment packages in a variety of combinations.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.26 |
| aws | >= 3.19 |
| random | >= 2 |

## Providers

| Name | Version |
|------|---------|
| random | >= 2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| lambda_function_from_package | ../../ |  |
| lambda_layer | ../../ |  |
| package_dir | ../../ |  |
| package_dir_without_pip_install | ../../ |  |
| package_file | ../../ |  |
| package_file_with_pip_requirements | ../../ |  |
| package_with_commands_and_patterns | ../../ |  |
| package_with_docker | ../../ |  |
| package_with_patterns | ../../ |  |
| package_with_pip_requirements_in_docker | ../../ |  |

## Resources

| Name |
|------|
| [random_pet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) |

## Inputs

No input.

## Outputs

No output.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
