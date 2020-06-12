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

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| appspec | n/a |
| appspec\_content | n/a |
| appspec\_sha256 | n/a |
| codedeploy\_app\_name | Name of CodeDeploy application |
| codedeploy\_deployment\_group\_id | CodeDeploy deployment group id |
| codedeploy\_deployment\_group\_name | CodeDeploy deployment group name |
| codedeploy\_iam\_role\_name | Name of IAM role used by CodeDeploy |
| deploy\_script | n/a |
| script | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
