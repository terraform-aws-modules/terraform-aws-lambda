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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.32 |
| <a name="requirement_http"></a> [http](#requirement\_http) | >= 3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.32 |
| <a name="provider_http"></a> [http](#provider\_http) | >= 3.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_go_lambda_function"></a> [go\_lambda\_function](#module\_go\_lambda\_function) | ../../ | n/a |
| <a name="module_java21_lambda_function"></a> [java21\_lambda\_function](#module\_java21\_lambda\_function) | ../../ | n/a |
| <a name="module_rust_lambda_function"></a> [rust\_lambda\_function](#module\_rust\_lambda\_function) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_lambda_invocation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lambda_invocation) | data source |
| [http_http.this](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_go_lambda_function_url"></a> [go\_lambda\_function\_url](#output\_go\_lambda\_function\_url) | The URL of the Lambda Function in Go |
| <a name="output_java21_lambda_function_arn"></a> [java21\_lambda\_function\_arn](#output\_java21\_lambda\_function\_arn) | The ARN of the Lambda Function in Java 21 |
| <a name="output_lambda_function_result"></a> [lambda\_function\_result](#output\_lambda\_function\_result) | The results of the Lambda Function calls |
| <a name="output_lambda_function_status_codes"></a> [lambda\_function\_status\_codes](#output\_lambda\_function\_status\_codes) | The status codes of the Lambda Function calls |
| <a name="output_rust_lambda_function_url"></a> [rust\_lambda\_function\_url](#output\_rust\_lambda\_function\_url) | The URL of the Lambda Function in Rust |
<!-- END_TF_DOCS -->
