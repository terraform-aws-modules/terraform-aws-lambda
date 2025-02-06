# Runtimes Examples

Configuration in this directory creates deployment packages for [various runtimes and programming languages (Rust, Go, Java)](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html).

Each runtime is executable by calling created Lambda Functions at the end.

Look into [Build Package Examples](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/build-package) for more ways to build package (regardless of the runtime).

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.79 |
| <a name="requirement_http"></a> [http](#requirement\_http) | >= 3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
