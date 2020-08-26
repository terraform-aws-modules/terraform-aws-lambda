# Lambda Function Deployment via AWS CodeDeploy

Terraform module, which creates Lambda alias as well as AWS CodeDeploy resources  required to deploy.

This Terraform module is the part of [serverless.tf framework](https://github.com/antonbabenko/serverless.tf), which aims to simplify all operations when working with the serverless in Terraform.

This module can create AWS CodeDeploy application and deployment group, if necessary. If you have several functions, you probably want to create those resources externally, and then set `use_existing_deployment_group = true`.

During deployment this module does the following:
1. Create JSON object with required AppSpec configuration. Optionally, you can store deploy script for debug purposes by setting `save_deploy_script = true`.
1. Run [`aws deploy create-deployment` command](https://docs.aws.amazon.com/cli/latest/reference/deploy/create-deployment.html) if `create_deployment = true` was set
1. After deployment is created, it can wait for the completion if `wait_deployment_completion = true`. Be aware, that Terraform will lock the execution and it can fail if it runs for a long period of time. Set this flag for fast deployments (eg, `deployment_config_name = "CodeDeployDefault.LambdaAllAtOnce"`).


## Usage

### Complete example of Lambda Function deployment via AWS CodeDeploy

```hcl
module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "my-lambda1"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  source_path = "../src/lambda-function1"
}

module "alias_refresh" {
  source = "terraform-aws-modules/lambda/aws//modules/alias"

  name          = "current-with-refresh"
  function_name = module.lambda_function.this_lambda_function_name

  # Set function_version when creating alias to be able to deploy using it,
  # because AWS CodeDeploy doesn't understand $LATEST as CurrentVersion.
  function_version = module.lambda_function.this_lambda_function_version
}

module "deploy" {
  source = "terraform-aws-modules/lambda/aws//modules/deploy"

  alias_name    = module.alias_refresh.this_lambda_alias_name
  function_name = module.lambda_function.this_lambda_function_name

  target_version = module.lambda_function.this_lambda_function_version

  create_app = true
  app_name   = "my-awesome-app"

  create_deployment_group = true
  deployment_group_name   = "something"

  create_deployment          = true
  wait_deployment_completion = true

  triggers = {
    start = {
      events     = ["DeploymentStart"]
      name       = "DeploymentStart"
      target_arn = "arn:aws:sns:eu-west-1:135367859851:sns1"
    }
    success = {
      events     = ["DeploymentSuccess"]
      name       = "DeploymentSuccess"
      target_arn = "arn:aws:sns:eu-west-1:135367859851:sns2"
    }
  }
}
```

## Conditional creation

Sometimes you need to have a way to create resources conditionally but Terraform does not allow usage of `count` inside `module` block, so the solution is to specify `create` arguments.

```hcl
module "lambda" {
  source = "terraform-aws-modules/lambda/aws//modules/deploy"

  create = false # to disable all resources

  create_app                    = false
  use_existing_app              = false
  create_deployment_group       = false
  use_existing_deployment_group = false

  # ... omitted
}
```

## Examples

* [Deploy](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/deploy) - Creates Lambda Function, Alias, and all resources required to create deployments using AWS CodeDeploy.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6, < 0.14 |
| aws | >= 2.67, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.67, < 4.0 |
| local | n/a |
| null | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| after\_allow\_traffic\_hook\_arn | ARN of Lambda function to execute after allow traffic during deployment | `string` | `""` | no |
| alarm\_enabled | Indicates whether the alarm configuration is enabled. This option is useful when you want to temporarily deactivate alarm monitoring for a deployment group without having to add the same alarms again later. | `bool` | `false` | no |
| alarm\_ignore\_poll\_alarm\_failure | Indicates whether a deployment should continue if information about the current state of alarms cannot be retrieved from CloudWatch. | `bool` | `false` | no |
| alarms | A list of alarms configured for the deployment group. A maximum of 10 alarms can be added to a deployment group. | `list(string)` | `[]` | no |
| alias\_name | Name for the alias | `string` | `""` | no |
| app\_name | Name of AWS CodeDeploy application | `string` | `""` | no |
| attach\_triggers\_policy | Whether to attach SNS policy to CodeDeploy role when triggers are defined | `bool` | `false` | no |
| auto\_rollback\_enabled | Indicates whether a defined automatic rollback configuration is currently enabled for this Deployment Group. | `bool` | `true` | no |
| auto\_rollback\_events | List of event types that trigger a rollback. Supported types are DEPLOYMENT\_FAILURE and DEPLOYMENT\_STOP\_ON\_ALARM. | `list(string)` | <pre>[<br>  "DEPLOYMENT_STOP_ON_ALARM"<br>]</pre> | no |
| aws\_cli\_command | Command to run as AWS CLI. May include extra arguments like region and profile. | `string` | `"aws"` | no |
| before\_allow\_traffic\_hook\_arn | ARN of Lambda function to execute before allow traffic during deployment | `string` | `""` | no |
| codedeploy\_principals | List of CodeDeploy service principals to allow. The list can include global or regional endpoints. | `list(string)` | <pre>[<br>  "codedeploy.amazonaws.com"<br>]</pre> | no |
| codedeploy\_role\_name | IAM role name to create or use by CodeDeploy | `string` | `""` | no |
| create | Controls whether resources should be created | `bool` | `true` | no |
| create\_app | Whether to create new AWS CodeDeploy app | `bool` | `false` | no |
| create\_codedeploy\_role | Whether to create new AWS CodeDeploy IAM role | `bool` | `true` | no |
| create\_deployment | Run AWS CLI command to create deployment | `bool` | `false` | no |
| create\_deployment\_group | Whether to create new AWS CodeDeploy Deployment Group | `bool` | `false` | no |
| current\_version | Current version of Lambda function version to deploy (can't be $LATEST) | `string` | `""` | no |
| deployment\_config\_name | Name of deployment config to use | `string` | `"CodeDeployDefault.LambdaAllAtOnce"` | no |
| deployment\_group\_name | Name of deployment group to use | `string` | `""` | no |
| description | Description to use for the deployment | `string` | `""` | no |
| force\_deploy | Force deployment every time (even when nothing changes) | `bool` | `false` | no |
| function\_name | The name of the Lambda function to deploy | `string` | `""` | no |
| save\_deploy\_script | Save deploy script locally | `bool` | `false` | no |
| target\_version | Target version of Lambda function version to deploy | `string` | `""` | no |
| triggers | Map of triggers which will be notified when event happens. Valid options for event types are DeploymentStart, DeploymentSuccess, DeploymentFailure, DeploymentStop, DeploymentRollback, DeploymentReady (Applies only to replacement instances in a blue/green deployment), InstanceStart, InstanceSuccess, InstanceFailure, InstanceReady. Note that not all are applicable for Lambda deployments. | `map(any)` | `{}` | no |
| use\_existing\_app | Whether to use existing AWS CodeDeploy app | `bool` | `false` | no |
| use\_existing\_deployment\_group | Whether to use existing AWS CodeDeploy Deployment Group | `bool` | `false` | no |
| wait\_deployment\_completion | Wait until deployment completes. It can take a lot of time and your terraform process may lock execution for long time. | `bool` | `false` | no |

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

## Authors

Module managed by [Anton Babenko](https://github.com/antonbabenko). Check out [serverless.tf](https://serverless.tf) to learn more about doing serverless with Terraform.

Please reach out to [Betajob](https://www.betajob.com/) if you are looking for commercial support for your Terraform, AWS, or serverless project.


## License

Apache 2 Licensed. See LICENSE for full details.
