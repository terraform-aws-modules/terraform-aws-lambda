# Function URL permissions example

This example creates IAM-authenticated Function URLs for an unqualified Lambda function and a named alias. An IAM role receives permission to invoke both URLs through `allowed_triggers`.

Each URL needs two permission statements:

- `lambda:InvokeFunctionUrl` with `function_url_auth_type = "AWS_IAM"`.
- `lambda:InvokeFunction` with `invoked_via_function_url = true`, restricting this permission to requests through a Function URL.

The invoker role has no identity policies. Its invocation permissions come from the function and alias resource policies, so it cannot invoke either target through the Lambda Invoke API. Other policies granting direct invocation would need to be considered separately.

Function URLs support the unqualified function and named aliases, not numbered versions. This example disables the additional version-specific permissions in both modules.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

Assume the role from the `invoker_role_arn` output using a principal in the same account that is authorized to call `sts:AssumeRole`. Sign HTTPS requests to either URL with those temporary credentials using AWS Signature Version 4 for the `lambda` service in `us-east-1`. Both requests should succeed, while `aws lambda invoke` with the same credentials should be denied for the function and the `live` alias.

See [Control access to Lambda function URLs](https://docs.aws.amazon.com/lambda/latest/dg/urls-auth.html) for the AWS permission model.

This example creates resources that can incur charges. Run `terraform destroy` when finished.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.28 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.28 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_alias"></a> [alias](#module\_alias) | ../../modules/alias | n/a |
| <a name="module_lambda_function"></a> [lambda\_function](#module\_lambda\_function) | ../../ | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_iam_role.invoker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_lambda_function_url.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_url) | resource |
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_invoker_role_arn"></a> [invoker\_role\_arn](#output\_invoker\_role\_arn) | The role to assume when testing invocation through the function URLs |
| <a name="output_lambda_alias_name"></a> [lambda\_alias\_name](#output\_lambda\_alias\_name) | The name of the Lambda alias |
| <a name="output_lambda_alias_url"></a> [lambda\_alias\_url](#output\_lambda\_alias\_url) | The IAM-authenticated URL of the Lambda alias |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | The name of the Lambda function |
| <a name="output_lambda_function_url"></a> [lambda\_function\_url](#output\_lambda\_function\_url) | The IAM-authenticated URL of the unqualified Lambda function |
<!-- END_TF_DOCS -->
