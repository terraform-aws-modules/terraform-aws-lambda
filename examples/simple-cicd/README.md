# Simple CI/CD example

Configuration in this directory creates AWS Lambda Function as it would run in a context of CICD executions, where the Terraform working directory is empty and there is no `builds` directory, that:

- `terraform plan` doesn't trigger a diff if the source code of the lambda function didn't change.
- `terraform plan` does trigger a diff if the source code of the lambda function has changed.
- `terraform apply` works if the code has changed.

## Usage

To run this example you need to execute:

```bash
./test.sh
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.32 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda_function"></a> [lambda\_function](#module\_lambda\_function) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
