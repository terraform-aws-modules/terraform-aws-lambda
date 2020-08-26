# AWS Lambda Alias

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
| terraform | >= 0.12.6, < 0.14 |
| aws | >= 2.67, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.67, < 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowed\_triggers | Map of allowed triggers to create Lambda permissions | `map(any)` | `{}` | no |
| create | Controls whether resources should be created | `bool` | `true` | no |
| create\_async\_event\_config | Controls whether async event configuration for Lambda Function/Alias should be created | `bool` | `false` | no |
| create\_qualified\_alias\_allowed\_triggers | Whether to allow triggers on qualified alias | `bool` | `true` | no |
| create\_qualified\_alias\_async\_event\_config | Whether to allow async event configuration on qualified alias | `bool` | `true` | no |
| create\_version\_allowed\_triggers | Whether to allow triggers on version of Lambda Function used by alias (this will revoke permissions from previous version because Terraform manages only current resources) | `bool` | `true` | no |
| create\_version\_async\_event\_config | Whether to allow async event configuration on version of Lambda Function used by alias (this will revoke permissions from previous version because Terraform manages only current resources) | `bool` | `true` | no |
| description | Description of the alias. | `string` | `""` | no |
| destination\_on\_failure | Amazon Resource Name (ARN) of the destination resource for failed asynchronous invocations | `string` | `null` | no |
| destination\_on\_success | Amazon Resource Name (ARN) of the destination resource for successful asynchronous invocations | `string` | `null` | no |
| function\_name | The function ARN of the Lambda function for which you want to create an alias. | `string` | `""` | no |
| function\_version | Lambda function version for which you are creating the alias. Pattern: ($LATEST\|[0-9]+). | `string` | `""` | no |
| maximum\_event\_age\_in\_seconds | Maximum age of a request that Lambda sends to a function for processing in seconds. Valid values between 60 and 21600. | `number` | `null` | no |
| maximum\_retry\_attempts | Maximum number of times to retry when the function returns an error. Valid values between 0 and 2. Defaults to 2. | `number` | `null` | no |
| name | Name for the alias you are creating. | `string` | `""` | no |
| refresh\_alias | Whether to refresh function version used in the alias. Useful when using this module together with external tool do deployments (eg, AWS CodeDeploy). | `bool` | `true` | no |
| routing\_additional\_version\_weights | A map that defines the proportion of events that should be sent to different versions of a lambda function. | `map(number)` | `{}` | no |
| use\_existing\_alias | Whether to manage existing alias instead of creating a new one. Useful when using this module together with external tool do deployments (eg, AWS CodeDeploy). | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| this\_lambda\_alias\_arn | The ARN of the Lambda Function Alias |
| this\_lambda\_alias\_description | Description of alias |
| this\_lambda\_alias\_function\_version | Lambda function version which the alias uses |
| this\_lambda\_alias\_invoke\_arn | The ARN to be used for invoking Lambda Function from API Gateway |
| this\_lambda\_alias\_name | The name of the Lambda Function Alias |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Anton Babenko](https://github.com/antonbabenko). Check out [serverless.tf](https://serverless.tf) to learn more about doing serverless with Terraform.

Please reach out to [Betajob](https://www.betajob.com/) if you are looking for commercial support for your Terraform, AWS, or serverless project.


## License

Apache 2 Licensed. See LICENSE for full details.
