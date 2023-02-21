# AWS Lambda launched from Docker Container Image example

Configuration in this directory creates AWS Lambda Function deployed with a Container Image.

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
| terraform | >= 0.13 |
| aws | >= 3.19 |
| random | >= 2 |

## Providers

| Name | Version |
|------|---------|
| random | >= 2 |

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| docker\_image\_uri | The ECR Docker image URI used to deploy Lambda Function |
| lambda\_cloudwatch\_log\_group\_arn | The ARN of the Cloudwatch Log Group |
| lambda\_function\_arn | The ARN of the Lambda Function |
| lambda\_function\_invoke\_arn | The Invoke ARN of the Lambda Function |
| lambda\_function\_kms\_key\_arn | The ARN for the KMS encryption key of Lambda Function |
| lambda\_function\_last\_modified | The date Lambda Function resource was last modified |
| lambda\_function\_name | The name of the Lambda Function |
| lambda\_function\_qualified\_arn | The ARN identifying your Lambda Function Version |
| lambda\_function\_source\_code\_hash | Base64-encoded representation of raw SHA-256 sum of the zip file |
| lambda\_function\_source\_code\_size | The size in bytes of the function .zip file |
| lambda\_function\_version | Latest published version of Lambda Function |
| lambda\_layer\_arn | The ARN of the Lambda Layer with version |
| lambda\_layer\_created\_date | The date Lambda Layer resource was created |
| lambda\_layer\_layer\_arn | The ARN of the Lambda Layer without version |
| lambda\_layer\_source\_code\_size | The size in bytes of the Lambda Layer .zip file |
| lambda\_layer\_version | The Lambda Layer version |
| lambda\_role\_arn | The ARN of the IAM role created for the Lambda Function |
| lambda\_role\_name | The name of the IAM role created for the Lambda Function |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
