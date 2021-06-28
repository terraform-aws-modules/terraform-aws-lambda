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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.26 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.19 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | >= 2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda_function_from_package"></a> [lambda\_function\_from\_package](#module\_lambda\_function\_from\_package) | ../../ |  |
| <a name="module_lambda_layer"></a> [lambda\_layer](#module\_lambda\_layer) | ../../ |  |
| <a name="module_package_dir"></a> [package\_dir](#module\_package\_dir) | ../../ |  |
| <a name="module_package_dir_without_pip_install"></a> [package\_dir\_without\_pip\_install](#module\_package\_dir\_without\_pip\_install) | ../../ |  |
| <a name="module_package_file"></a> [package\_file](#module\_package\_file) | ../../ |  |
| <a name="module_package_file_with_pip_requirements"></a> [package\_file\_with\_pip\_requirements](#module\_package\_file\_with\_pip\_requirements) | ../../ |  |
| <a name="module_package_with_commands_and_patterns"></a> [package\_with\_commands\_and\_patterns](#module\_package\_with\_commands\_and\_patterns) | ../../ |  |
| <a name="module_package_with_docker"></a> [package\_with\_docker](#module\_package\_with\_docker) | ../../ |  |
| <a name="module_package_with_patterns"></a> [package\_with\_patterns](#module\_package\_with\_patterns) | ../../ |  |
| <a name="module_package_with_pip_requirements_in_docker"></a> [package\_with\_pip\_requirements\_in\_docker](#module\_package\_with\_pip\_requirements\_in\_docker) | ../../ |  |

## Resources

| Name | Type |
|------|------|
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
