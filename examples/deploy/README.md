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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6 |
| aws | >= 3.19 |
| random | >= 2 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.19 |
| random | >= 2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| alias_refresh | ../../modules/alias |  |
| deploy | ../../modules/deploy |  |
| lambda_function | ../../ |  |

## Resources

| Name |
|------|
| [aws_sns_topic](https://registry.terraform.io/providers/hashicorp/aws/3.19/docs/resources/sns_topic) |
| [random_pet](https://registry.terraform.io/providers/hashicorp/random/2/docs/resources/pet) |

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| appspec | Appspec data as HCL |
| appspec\_content | Appspec data as valid JSON |
| appspec\_sha256 | SHA256 of Appspec JSON |
| codedeploy\_app\_name | Name of CodeDeploy application |
| codedeploy\_deployment\_group\_id | CodeDeploy deployment group id |
| codedeploy\_deployment\_group\_name | CodeDeploy deployment group name |
| codedeploy\_iam\_role\_name | Name of IAM role used by CodeDeploy |
| deploy\_script | Path to a deployment script |
| script | Deployment script |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
