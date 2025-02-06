# AWS Lambda with VPC and VPC Endpoint for S3 example

The configuration in this directory creates an AWS Lambda Function deployed within a VPC with a VPC Endpoint for S3 and no Internet access. The Function writes a single object to an S3 bucket that is created as part of the supporting resources.

Be aware, that deletion of AWS Lambda with VPC can take a long time (e.g., 10 minutes).

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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.79 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4 |

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
