# Build Package Examples

Configuration in this directory creates deployment packages in a variety of combinations.

Look into [Runtimes Examples](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/runtimes) for more ways to build and deploy AWS Lambda Functions using supported runtimes (Rust, Go, Java).

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda_function_from_package"></a> [lambda\_function\_from\_package](#module\_lambda\_function\_from\_package) | ../../ | n/a |
| <a name="module_lambda_layer"></a> [lambda\_layer](#module\_lambda\_layer) | ../../ | n/a |
| <a name="module_lambda_layer_pip_requirements"></a> [lambda\_layer\_pip\_requirements](#module\_lambda\_layer\_pip\_requirements) | ../.. | n/a |
| <a name="module_lambda_layer_poetry"></a> [lambda\_layer\_poetry](#module\_lambda\_layer\_poetry) | ../../ | n/a |
| <a name="module_npm_package_with_commands_and_patterns"></a> [npm\_package\_with\_commands\_and\_patterns](#module\_npm\_package\_with\_commands\_and\_patterns) | ../../ | n/a |
| <a name="module_package_dir"></a> [package\_dir](#module\_package\_dir) | ../../ | n/a |
| <a name="module_package_dir_pip_dir"></a> [package\_dir\_pip\_dir](#module\_package\_dir\_pip\_dir) | ../../ | n/a |
| <a name="module_package_dir_poetry"></a> [package\_dir\_poetry](#module\_package\_dir\_poetry) | ../../ | n/a |
| <a name="module_package_dir_poetry_no_docker"></a> [package\_dir\_poetry\_no\_docker](#module\_package\_dir\_poetry\_no\_docker) | ../../ | n/a |
| <a name="module_package_dir_with_npm_install"></a> [package\_dir\_with\_npm\_install](#module\_package\_dir\_with\_npm\_install) | ../../ | n/a |
| <a name="module_package_dir_with_npm_install_lock_file"></a> [package\_dir\_with\_npm\_install\_lock\_file](#module\_package\_dir\_with\_npm\_install\_lock\_file) | ../../ | n/a |
| <a name="module_package_dir_without_npm_install"></a> [package\_dir\_without\_npm\_install](#module\_package\_dir\_without\_npm\_install) | ../../ | n/a |
| <a name="module_package_dir_without_pip_install"></a> [package\_dir\_without\_pip\_install](#module\_package\_dir\_without\_pip\_install) | ../../ | n/a |
| <a name="module_package_file"></a> [package\_file](#module\_package\_file) | ../../ | n/a |
| <a name="module_package_file_with_pip_requirements"></a> [package\_file\_with\_pip\_requirements](#module\_package\_file\_with\_pip\_requirements) | ../../ | n/a |
| <a name="module_package_src_poetry"></a> [package\_src\_poetry](#module\_package\_src\_poetry) | ../../ | n/a |
| <a name="module_package_src_poetry2"></a> [package\_src\_poetry2](#module\_package\_src\_poetry2) | ../../ | n/a |
| <a name="module_package_with_commands_and_patterns"></a> [package\_with\_commands\_and\_patterns](#module\_package\_with\_commands\_and\_patterns) | ../../ | n/a |
| <a name="module_package_with_docker"></a> [package\_with\_docker](#module\_package\_with\_docker) | ../../ | n/a |
| <a name="module_package_with_npm_lock_in_docker"></a> [package\_with\_npm\_lock\_in\_docker](#module\_package\_with\_npm\_lock\_in\_docker) | ../../ | n/a |
| <a name="module_package_with_npm_requirements_in_docker"></a> [package\_with\_npm\_requirements\_in\_docker](#module\_package\_with\_npm\_requirements\_in\_docker) | ../../ | n/a |
| <a name="module_package_with_patterns"></a> [package\_with\_patterns](#module\_package\_with\_patterns) | ../../ | n/a |
| <a name="module_package_with_pip_requirements_in_docker"></a> [package\_with\_pip\_requirements\_in\_docker](#module\_package\_with\_pip\_requirements\_in\_docker) | ../../ | n/a |
| <a name="module_package_with_pip_requirements_in_docker_overriding_entrypoint"></a> [package\_with\_pip\_requirements\_in\_docker\_overriding\_entrypoint](#module\_package\_with\_pip\_requirements\_in\_docker\_overriding\_entrypoint) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
