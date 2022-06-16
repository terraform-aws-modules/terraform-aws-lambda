# Lambda Alias

Configuration in this directory creates Lambda Function and Aliases in different configurations.

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.19 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alias_existing"></a> [alias\_existing](#module\_alias\_existing) | ../../modules/alias | n/a |
| <a name="module_alias_no_refresh"></a> [alias\_no\_refresh](#module\_alias\_no\_refresh) | ../../modules/alias | n/a |
| <a name="module_alias_refresh"></a> [alias\_refresh](#module\_alias\_refresh) | ../../modules/alias | n/a |
| <a name="module_lambda_function"></a> [lambda\_function](#module\_lambda\_function) | ../../ | n/a |
| <a name="module_sqs_events"></a> [sqs\_events](#module\_sqs\_events) | terraform-aws-modules/sqs/aws | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_alias_arn"></a> [lambda\_alias\_arn](#output\_lambda\_alias\_arn) | The ARN of the Lambda Function Alias |
| <a name="output_lambda_alias_description"></a> [lambda\_alias\_description](#output\_lambda\_alias\_description) | Description of alias |
| <a name="output_lambda_alias_event_source_mapping_function_arn"></a> [lambda\_alias\_event\_source\_mapping\_function\_arn](#output\_lambda\_alias\_event\_source\_mapping\_function\_arn) | The the ARN of the Lambda function the event source mapping is sending events to |
| <a name="output_lambda_alias_event_source_mapping_state"></a> [lambda\_alias\_event\_source\_mapping\_state](#output\_lambda\_alias\_event\_source\_mapping\_state) | The state of the event source mapping |
| <a name="output_lambda_alias_event_source_mapping_state_transition_reason"></a> [lambda\_alias\_event\_source\_mapping\_state\_transition\_reason](#output\_lambda\_alias\_event\_source\_mapping\_state\_transition\_reason) | The reason the event source mapping is in its current state |
| <a name="output_lambda_alias_event_source_mapping_uuid"></a> [lambda\_alias\_event\_source\_mapping\_uuid](#output\_lambda\_alias\_event\_source\_mapping\_uuid) | The UUID of the created event source mapping |
| <a name="output_lambda_alias_function_version"></a> [lambda\_alias\_function\_version](#output\_lambda\_alias\_function\_version) | Lambda function version which the alias uses |
| <a name="output_lambda_alias_invoke_arn"></a> [lambda\_alias\_invoke\_arn](#output\_lambda\_alias\_invoke\_arn) | The ARN to be used for invoking Lambda Function from API Gateway |
| <a name="output_lambda_alias_name"></a> [lambda\_alias\_name](#output\_lambda\_alias\_name) | The name of the Lambda Function Alias |
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | The ARN of the Lambda Function |
| <a name="output_lambda_function_invoke_arn"></a> [lambda\_function\_invoke\_arn](#output\_lambda\_function\_invoke\_arn) | The Invoke ARN of the Lambda Function |
| <a name="output_lambda_function_kms_key_arn"></a> [lambda\_function\_kms\_key\_arn](#output\_lambda\_function\_kms\_key\_arn) | The ARN for the KMS encryption key of Lambda Function |
| <a name="output_lambda_function_last_modified"></a> [lambda\_function\_last\_modified](#output\_lambda\_function\_last\_modified) | The date Lambda Function resource was last modified |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | The name of the Lambda Function |
| <a name="output_lambda_function_qualified_arn"></a> [lambda\_function\_qualified\_arn](#output\_lambda\_function\_qualified\_arn) | The ARN identifying your Lambda Function Version |
| <a name="output_lambda_function_source_code_hash"></a> [lambda\_function\_source\_code\_hash](#output\_lambda\_function\_source\_code\_hash) | Base64-encoded representation of raw SHA-256 sum of the zip file |
| <a name="output_lambda_function_source_code_size"></a> [lambda\_function\_source\_code\_size](#output\_lambda\_function\_source\_code\_size) | The size in bytes of the function .zip file |
| <a name="output_lambda_function_version"></a> [lambda\_function\_version](#output\_lambda\_function\_version) | Latest published version of Lambda Function |
| <a name="output_lambda_layer_arn"></a> [lambda\_layer\_arn](#output\_lambda\_layer\_arn) | The ARN of the Lambda Layer with version |
| <a name="output_lambda_layer_created_date"></a> [lambda\_layer\_created\_date](#output\_lambda\_layer\_created\_date) | The date Lambda Layer resource was created |
| <a name="output_lambda_layer_layer_arn"></a> [lambda\_layer\_layer\_arn](#output\_lambda\_layer\_layer\_arn) | The ARN of the Lambda Layer without version |
| <a name="output_lambda_layer_source_code_size"></a> [lambda\_layer\_source\_code\_size](#output\_lambda\_layer\_source\_code\_size) | The size in bytes of the Lambda Layer .zip file |
| <a name="output_lambda_layer_version"></a> [lambda\_layer\_version](#output\_lambda\_layer\_version) | The Lambda Layer version |
| <a name="output_lambda_role_arn"></a> [lambda\_role\_arn](#output\_lambda\_role\_arn) | The ARN of the IAM role created for the Lambda Function |
| <a name="output_lambda_role_name"></a> [lambda\_role\_name](#output\_lambda\_role\_name) | The name of the IAM role created for the Lambda Function |
| <a name="output_local_filename"></a> [local\_filename](#output\_local\_filename) | The filename of zip archive deployed (if deployment was from local) |
| <a name="output_s3_object"></a> [s3\_object](#output\_s3\_object) | The map with S3 object data of zip archive deployed (if deployment was from S3) |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
