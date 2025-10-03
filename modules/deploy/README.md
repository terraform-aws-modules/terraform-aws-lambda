# Lambda Function Deployment via AWS CodeDeploy

Terraform module, which creates Lambda alias as well as AWS CodeDeploy resources required to deploy.

This Terraform module is the part of [serverless.tf framework](https://github.com/antonbabenko/serverless.tf), which aims to simplify all operations when working with the serverless in Terraform.

This module can create AWS CodeDeploy application and deployment group, if necessary. If you have several functions, you probably want to create those resources externally, and then set `use_existing_deployment_group = true`.

During deployment this module does the following:

1. Create JSON object with required AppSpec configuration. Optionally, you can store deploy script for debug purposes by setting `save_deploy_script = true`.
1. Run [`aws deploy create-deployment` command](https://docs.aws.amazon.com/cli/latest/reference/deploy/create-deployment.html) if `create_deployment = true` and `run_deployment = true` was set.
1. After deployment is created, it can wait for the completion if `wait_deployment_completion = true`. Be aware, that Terraform will lock the execution and it can fail if it runs for a long period of time. Set this flag for fast deployments (eg, `deployment_config_name = "CodeDeployDefault.LambdaAllAtOnce"`).

## Usage

### Complete example of Lambda Function deployment via AWS CodeDeploy

```hcl
module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "my-lambda1"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"

  source_path = "../src/lambda-function1"
}

module "alias_refresh" {
  source = "terraform-aws-modules/lambda/aws//modules/alias"

  name          = "current-with-refresh"
  function_name = module.lambda_function.lambda_function_name

  # Set function_version when creating alias to be able to deploy using it,
  # because AWS CodeDeploy doesn't understand $LATEST as CurrentVersion.
  function_version = module.lambda_function.lambda_function_version
}

module "deploy" {
  source = "terraform-aws-modules/lambda/aws//modules/deploy"

  alias_name    = module.alias_refresh.lambda_alias_name
  function_name = module.lambda_function.lambda_function_name

  target_version = module.lambda_function.lambda_function_version

  create_app = true
  app_name   = "my-awesome-app"

  create_deployment_group = true
  deployment_group_name   = "something"

  create_deployment          = true
  run_deployment             = true
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

- [Deploy](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/deploy) - Creates Lambda Function, Alias, and all resources required to create deployments using AWS CodeDeploy.

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version |
| ------------------------------------------------------------------------ | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.3  |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 3.35 |
| <a name="requirement_local"></a> [local](#requirement_local)             | >= 1.3  |
| <a name="requirement_null"></a> [null](#requirement_null)                | >= 2.0  |

## Providers

| Name                                                   | Version |
| ------------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws)       | >= 3.35 |
| <a name="provider_local"></a> [local](#provider_local) | >= 1.3  |
| <a name="provider_null"></a> [null](#provider_null)    | >= 2.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                                                | Type        |
| --------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_codedeploy_app.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app)                               | resource    |
| [aws_codedeploy_deployment_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group)     | resource    |
| [aws_iam_policy.hooks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                      | resource    |
| [aws_iam_policy.triggers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                   | resource    |
| [aws_iam_role.codedeploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                     | resource    |
| [aws_iam_role_policy_attachment.codedeploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_iam_role_policy_attachment.hooks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)      | resource    |
| [aws_iam_role_policy_attachment.triggers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)   | resource    |
| [local_file.deploy_script](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file)                                      | resource    |
| [null_resource.deploy](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource)                                       | resource    |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)           | data source |
| [aws_iam_policy_document.hooks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                 | data source |
| [aws_iam_policy_document.triggers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)              | data source |
| [aws_iam_role.codedeploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role)                                  | data source |
| [aws_lambda_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lambda_alias)                                | data source |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lambda_function)                          | data source |

## Inputs

| Name                                                                                                                           | Description                                                                                                                                                                                                                                                                                                                                                                                          | Type           | Default                                            | Required |
| ------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | -------------------------------------------------- | :------: |
| <a name="input_after_allow_traffic_hook_arn"></a> [after_allow_traffic_hook_arn](#input_after_allow_traffic_hook_arn)          | ARN of Lambda function to execute after allow traffic during deployment. This function should be named CodeDeployHook\_, to match the managed AWSCodeDeployForLambda policy, unless you're using a custom role                                                                                                                                                                                       | `string`       | `""`                                               |    no    |
| <a name="input_alarm_enabled"></a> [alarm_enabled](#input_alarm_enabled)                                                       | Indicates whether the alarm configuration is enabled. This option is useful when you want to temporarily deactivate alarm monitoring for a deployment group without having to add the same alarms again later.                                                                                                                                                                                       | `bool`         | `false`                                            |    no    |
| <a name="input_alarm_ignore_poll_alarm_failure"></a> [alarm_ignore_poll_alarm_failure](#input_alarm_ignore_poll_alarm_failure) | Indicates whether a deployment should continue if information about the current state of alarms cannot be retrieved from CloudWatch.                                                                                                                                                                                                                                                                 | `bool`         | `false`                                            |    no    |
| <a name="input_alarms"></a> [alarms](#input_alarms)                                                                            | A list of alarms configured for the deployment group. A maximum of 10 alarms can be added to a deployment group.                                                                                                                                                                                                                                                                                     | `list(string)` | `[]`                                               |    no    |
| <a name="input_alias_name"></a> [alias_name](#input_alias_name)                                                                | Name for the alias                                                                                                                                                                                                                                                                                                                                                                                   | `string`       | `""`                                               |    no    |
| <a name="input_app_name"></a> [app_name](#input_app_name)                                                                      | Name of AWS CodeDeploy application                                                                                                                                                                                                                                                                                                                                                                   | `string`       | `""`                                               |    no    |
| <a name="input_attach_hooks_policy"></a> [attach_hooks_policy](#input_attach_hooks_policy)                                     | Whether to attach Invoke policy to CodeDeploy role when before allow traffic or after allow traffic hooks are defined.                                                                                                                                                                                                                                                                               | `bool`         | `true`                                             |    no    |
| <a name="input_attach_triggers_policy"></a> [attach_triggers_policy](#input_attach_triggers_policy)                            | Whether to attach SNS policy to CodeDeploy role when triggers are defined                                                                                                                                                                                                                                                                                                                            | `bool`         | `false`                                            |    no    |
| <a name="input_auto_rollback_enabled"></a> [auto_rollback_enabled](#input_auto_rollback_enabled)                               | Indicates whether a defined automatic rollback configuration is currently enabled for this Deployment Group.                                                                                                                                                                                                                                                                                         | `bool`         | `true`                                             |    no    |
| <a name="input_auto_rollback_events"></a> [auto_rollback_events](#input_auto_rollback_events)                                  | List of event types that trigger a rollback. Supported types are DEPLOYMENT_FAILURE and DEPLOYMENT_STOP_ON_ALARM.                                                                                                                                                                                                                                                                                    | `list(string)` | <pre>[<br/> "DEPLOYMENT_STOP_ON_ALARM"<br/>]</pre> |    no    |
| <a name="input_aws_cli_command"></a> [aws_cli_command](#input_aws_cli_command)                                                 | Command to run as AWS CLI. May include extra arguments like region and profile.                                                                                                                                                                                                                                                                                                                      | `string`       | `"aws"`                                            |    no    |
| <a name="input_before_allow_traffic_hook_arn"></a> [before_allow_traffic_hook_arn](#input_before_allow_traffic_hook_arn)       | ARN of Lambda function to execute before allow traffic during deployment. This function should be named CodeDeployHook\_, to match the managed AWSCodeDeployForLambda policy, unless you're using a custom role                                                                                                                                                                                      | `string`       | `""`                                               |    no    |
| <a name="input_codedeploy_principals"></a> [codedeploy_principals](#input_codedeploy_principals)                               | List of CodeDeploy service principals to allow. The list can include global or regional endpoints.                                                                                                                                                                                                                                                                                                   | `list(string)` | <pre>[<br/> "codedeploy.amazonaws.com"<br/>]</pre> |    no    |
| <a name="input_codedeploy_role_name"></a> [codedeploy_role_name](#input_codedeploy_role_name)                                  | IAM role name to create or use by CodeDeploy                                                                                                                                                                                                                                                                                                                                                         | `string`       | `""`                                               |    no    |
| <a name="input_create"></a> [create](#input_create)                                                                            | Controls whether resources should be created                                                                                                                                                                                                                                                                                                                                                         | `bool`         | `true`                                             |    no    |
| <a name="input_create_app"></a> [create_app](#input_create_app)                                                                | Whether to create new AWS CodeDeploy app                                                                                                                                                                                                                                                                                                                                                             | `bool`         | `false`                                            |    no    |
| <a name="input_create_codedeploy_role"></a> [create_codedeploy_role](#input_create_codedeploy_role)                            | Whether to create new AWS CodeDeploy IAM role                                                                                                                                                                                                                                                                                                                                                        | `bool`         | `true`                                             |    no    |
| <a name="input_create_deployment"></a> [create_deployment](#input_create_deployment)                                           | Create the AWS resources and script for CodeDeploy                                                                                                                                                                                                                                                                                                                                                   | `bool`         | `false`                                            |    no    |
| <a name="input_create_deployment_group"></a> [create_deployment_group](#input_create_deployment_group)                         | Whether to create new AWS CodeDeploy Deployment Group                                                                                                                                                                                                                                                                                                                                                | `bool`         | `false`                                            |    no    |
| <a name="input_current_version"></a> [current_version](#input_current_version)                                                 | Current version of Lambda function version to deploy (can't be $LATEST)                                                                                                                                                                                                                                                                                                                              | `string`       | `""`                                               |    no    |
| <a name="input_deployment_config_name"></a> [deployment_config_name](#input_deployment_config_name)                            | Name of deployment config to use                                                                                                                                                                                                                                                                                                                                                                     | `string`       | `"CodeDeployDefault.LambdaAllAtOnce"`              |    no    |
| <a name="input_deployment_group_name"></a> [deployment_group_name](#input_deployment_group_name)                               | Name of deployment group to use                                                                                                                                                                                                                                                                                                                                                                      | `string`       | `""`                                               |    no    |
| <a name="input_description"></a> [description](#input_description)                                                             | Description to use for the deployment                                                                                                                                                                                                                                                                                                                                                                | `string`       | `""`                                               |    no    |
| <a name="input_force_deploy"></a> [force_deploy](#input_force_deploy)                                                          | Force deployment every time (even when nothing changes)                                                                                                                                                                                                                                                                                                                                              | `bool`         | `false`                                            |    no    |
| <a name="input_function_name"></a> [function_name](#input_function_name)                                                       | The name of the Lambda function to deploy                                                                                                                                                                                                                                                                                                                                                            | `string`       | `""`                                               |    no    |
| <a name="input_get_deployment_sleep_timer"></a> [get_deployment_sleep_timer](#input_get_deployment_sleep_timer)                | Adds additional sleep time to get-deployment command to avoid the service throttling                                                                                                                                                                                                                                                                                                                 | `number`       | `5`                                                |    no    |
| <a name="input_interpreter"></a> [interpreter](#input_interpreter)                                                             | List of interpreter arguments used to execute deploy script, first arg is path                                                                                                                                                                                                                                                                                                                       | `list(string)` | <pre>[<br/> "/bin/bash",<br/> "-c"<br/>]</pre>     |    no    |
| <a name="input_run_deployment"></a> [run_deployment](#input_run_deployment)                                                    | Run AWS CLI command to start the deployment                                                                                                                                                                                                                                                                                                                                                          | `bool`         | `false`                                            |    no    |
| <a name="input_save_deploy_script"></a> [save_deploy_script](#input_save_deploy_script)                                        | Save deploy script locally                                                                                                                                                                                                                                                                                                                                                                           | `bool`         | `false`                                            |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                                  | A map of tags to assign to resources.                                                                                                                                                                                                                                                                                                                                                                | `map(string)`  | `{}`                                               |    no    |
| <a name="input_target_version"></a> [target_version](#input_target_version)                                                    | Target version of Lambda function version to deploy                                                                                                                                                                                                                                                                                                                                                  | `string`       | `""`                                               |    no    |
| <a name="input_triggers"></a> [triggers](#input_triggers)                                                                      | Map of triggers which will be notified when event happens. Valid options for event types are DeploymentStart, DeploymentSuccess, DeploymentFailure, DeploymentStop, DeploymentRollback, DeploymentReady (Applies only to replacement instances in a blue/green deployment), InstanceStart, InstanceSuccess, InstanceFailure, InstanceReady. Note that not all are applicable for Lambda deployments. | `map(any)`     | `{}`                                               |    no    |
| <a name="input_use_existing_app"></a> [use_existing_app](#input_use_existing_app)                                              | Whether to use existing AWS CodeDeploy app                                                                                                                                                                                                                                                                                                                                                           | `bool`         | `false`                                            |    no    |
| <a name="input_use_existing_deployment_group"></a> [use_existing_deployment_group](#input_use_existing_deployment_group)       | Whether to use existing AWS CodeDeploy Deployment Group                                                                                                                                                                                                                                                                                                                                              | `bool`         | `false`                                            |    no    |
| <a name="input_wait_deployment_completion"></a> [wait_deployment_completion](#input_wait_deployment_completion)                | Wait until deployment completes. It can take a lot of time and your terraform process may lock execution for long time.                                                                                                                                                                                                                                                                              | `bool`         | `false`                                            |    no    |

## Outputs

| Name                                                                                                                                | Description                         |
| ----------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| <a name="output_appspec"></a> [appspec](#output_appspec)                                                                            | Appspec data as HCL                 |
| <a name="output_appspec_content"></a> [appspec_content](#output_appspec_content)                                                    | Appspec data as valid JSON          |
| <a name="output_appspec_sha256"></a> [appspec_sha256](#output_appspec_sha256)                                                       | SHA256 of Appspec JSON              |
| <a name="output_codedeploy_app_name"></a> [codedeploy_app_name](#output_codedeploy_app_name)                                        | Name of CodeDeploy application      |
| <a name="output_codedeploy_deployment_group_id"></a> [codedeploy_deployment_group_id](#output_codedeploy_deployment_group_id)       | CodeDeploy deployment group id      |
| <a name="output_codedeploy_deployment_group_name"></a> [codedeploy_deployment_group_name](#output_codedeploy_deployment_group_name) | CodeDeploy deployment group name    |
| <a name="output_codedeploy_iam_role_name"></a> [codedeploy_iam_role_name](#output_codedeploy_iam_role_name)                         | Name of IAM role used by CodeDeploy |
| <a name="output_deploy_script"></a> [deploy_script](#output_deploy_script)                                                          | Path to a deployment script         |
| <a name="output_script"></a> [script](#output_script)                                                                               | Deployment script                   |

<!-- END_TF_DOCS -->

## Authors

Module managed by [Anton Babenko](https://github.com/antonbabenko). Check out [serverless.tf](https://serverless.tf) to learn more about doing serverless with Terraform.

Please reach out to [Betajob](https://www.betajob.com/) if you are looking for commercial support for your Terraform, AWS, or serverless project.

## License

Apache 2 Licensed. See LICENSE for full details.
