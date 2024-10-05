# Lambda Function Deployments using AWS CodeDeploy

Configuration in this directory creates Lambda Function, Alias, and all resources required to create deployments using AWS CodeDeploy, and then it does a real deployment.

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.32 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.32 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alias_refresh"></a> [alias\_refresh](#module\_alias\_refresh) | ../../modules/alias | n/a |
| <a name="module_deploy"></a> [deploy](#module\_deploy) | ../../modules/deploy | n/a |
| <a name="module_lambda_function"></a> [lambda\_function](#module\_lambda\_function) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_sns_topic.sns1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic.sns2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_appspec"></a> [appspec](#output\_appspec) | Appspec data as HCL |
| <a name="output_appspec_content"></a> [appspec\_content](#output\_appspec\_content) | Appspec data as valid JSON |
| <a name="output_appspec_sha256"></a> [appspec\_sha256](#output\_appspec\_sha256) | SHA256 of Appspec JSON |
| <a name="output_codedeploy_app_name"></a> [codedeploy\_app\_name](#output\_codedeploy\_app\_name) | Name of CodeDeploy application |
| <a name="output_codedeploy_deployment_group_id"></a> [codedeploy\_deployment\_group\_id](#output\_codedeploy\_deployment\_group\_id) | CodeDeploy deployment group id |
| <a name="output_codedeploy_deployment_group_name"></a> [codedeploy\_deployment\_group\_name](#output\_codedeploy\_deployment\_group\_name) | CodeDeploy deployment group name |
| <a name="output_codedeploy_iam_role_name"></a> [codedeploy\_iam\_role\_name](#output\_codedeploy\_iam\_role\_name) | Name of IAM role used by CodeDeploy |
| <a name="output_deploy_script"></a> [deploy\_script](#output\_deploy\_script) | Path to a deployment script |
| <a name="output_script"></a> [script](#output\_script) | Deployment script |
<!-- END_TF_DOCS -->
