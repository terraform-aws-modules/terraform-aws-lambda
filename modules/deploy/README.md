# Trigger Lambda Function Deployments via AWS CodeDeploy

Terraform module, which creates Lambda alias as well as takes care of async event configuration and Lambda permissions for alias.

Lambda Alias is required to do complex Lambda deployments, eg. using external tools like AWS CodeDeploy.

This Terraform module is the part of [serverless.tf framework](https://github.com/antonbabenko/serverless.tf), which aims to simplify all operations when working with the serverless in Terraform.


## Usage

### Lambda Function and statically configured alias with the version of Lambda Function

```hcl
module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "my-lambda1"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  source_path = "../src/lambda-function1"
}

module "alias_no_refresh" {
  source = "terraform-aws-modules/lambda/aws//modules/alias"

  refresh_alias = false

  name = "current-no-refresh"

  function_name    = module.lambda_function.this_lambda_function_name
  function_version = module.lambda_function.this_lambda_function_version

  allowed_triggers = {
    AnotherAPIGatewayAny = {
      service = "apigateway"
      arn = "arn:aws:execute-api:eu-west-1:135367859851:abcdedfgse"
    }
  }
}
```

### Lambda Alias (auto-refreshing when version changed externally)

This is useful when doing complex deployments using external tool.

```hcl
module "alias_refresh" {
  source = "terraform-aws-modules/lambda/aws//modules/alias"

  name          = "current-with-refresh"
  function_name = module.lambda_function.this_lambda_function_name
}
```

### Lambda Alias (using existing alias)

This is useful when extra configuration on existing Lambda alias is required.

```hcl
module "alias_refresh" {
  source = "terraform-aws-modules/lambda/aws//modules/alias"

  name          = "current-with-refresh"
  function_name = module.lambda_function.this_lambda_function_name
}

module "alias_existing" {
  source = "terraform-aws-modules/lambda/aws//modules/alias"

  use_existing_alias = true

  name          = module.alias_refresh.this_lambda_alias_name
  function_name = module.lambda_function.this_lambda_function_name

  allowed_triggers = {
    AnotherAwesomeAPIGateway = {
      service = "apigateway"
      arn     = "arn:aws:execute-api:eu-west-1:999967859851:aqnku8akd0"
    }
  }
}
```


## Conditional creation

Sometimes you need to have a way to create resources conditionally but Terraform does not allow usage of `count` inside `module` block, so the solution is to specify `create` arguments.

```hcl
module "lambda" {
  source = "terraform-aws-modules/lambda/aws//modules/alias"

  create = false # to disable all resources

  create_async_event_config                 = false  # to control async configs
  create_version_async_event_config         = false
  create_qualified_alias_async_event_config = false

  create_version_allowed_triggers         = false # to control allowed triggers on version
  create_qualified_alias_allowed_triggers = false # to control allowed triggers on alias

  # ... omitted
}
```

## Examples

* [Alias](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/alias) - Create Lambda function and aliases in various combinations with all supported features.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.6 |
| aws | ~> 2.46 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.46 |
| local | n/a |
| null | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| after\_allow\_traffic\_hook\_arn | ARN of Lambda function to execute after allow traffic during deployment | `string` | `""` | no |
| alias\_name | Name for the alias | `string` | `""` | no |
| app\_name | Name of AWS CodeDeploy application | `string` | `""` | no |
| before\_allow\_traffic\_hook\_arn | ARN of Lambda function to execute before allow traffic during deployment | `string` | `""` | no |
| create | Controls whether resources should be created | `bool` | `true` | no |
| create\_app | Whether to create new AWS CodeDeploy app | `bool` | `false` | no |
| create\_deployment | Run AWS CLI command to create deployment | `bool` | `false` | no |
| create\_deployment\_group | Whether to create new AWS CodeDeploy Deployment Group | `bool` | `false` | no |
| current\_version | Current version of Lambda function version to deploy (can't be $LATEST) | `string` | `""` | no |
| deployment\_config\_name | Name of deployment config to use | `string` | `"CodeDeployDefault.LambdaAllAtOnce"` | no |
| deployment\_group\_name | Name of deployment group to use | `string` | `""` | no |
| function\_name | The name of the Lambda function to deploy | `string` | `""` | no |
| save\_deploy\_script | Save deploy script locally | `bool` | `false` | no |
| target\_version | Target version of Lambda function version to deploy | `string` | `""` | no |
| use\_existing\_app | Whether to use existing AWS CodeDeploy app | `bool` | `false` | no |
| use\_existing\_deployment\_group | Whether to use existing AWS CodeDeploy Deployment Group | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| appspec | n/a |
| appspec\_json | n/a |
| appspec\_json\_sha256 | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Anton Babenko](https://github.com/antonbabenko). Check out [serverless.tf](https://serverless.tf) to learn more about doing serverless with Terraform.

Please reach out to [Betajob](https://www.betajob.com/) if you are looking for commercial support for your Terraform, AWS, or serverless project.


## License

Apache 2 Licensed. See LICENSE for full details.
