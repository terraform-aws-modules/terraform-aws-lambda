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
  runtime       = "python3.12"

  source_path = "../src/lambda-function1"
}

module "alias_no_refresh" {
  source = "terraform-aws-modules/lambda/aws//modules/alias"

  refresh_alias = false

  name = "current-no-refresh"

  function_name    = module.lambda_function.lambda_function_name
  function_version = module.lambda_function.lambda_function_version

  allowed_triggers = {
    AnotherAPIGatewayAny = {
      service    = "apigateway"
      source_arn = "arn:aws:execute-api:eu-west-1:135367859851:abcdedfgse/*/*/*"
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
  function_name = module.lambda_function.lambda_function_name
}
```

### Lambda Alias (using existing alias)

This is useful when extra configuration on existing Lambda alias is required.

```hcl
module "alias_refresh" {
  source = "terraform-aws-modules/lambda/aws//modules/alias"

  name          = "current-with-refresh"
  function_name = module.lambda_function.lambda_function_name
}

module "alias_existing" {
  source = "terraform-aws-modules/lambda/aws//modules/alias"

  use_existing_alias = true

  name          = module.alias_refresh.lambda_alias_name
  function_name = module.lambda_function.lambda_function_name

  allowed_triggers = {
    AnotherAwesomeAPIGateway = {
      service    = "apigateway"
      source_arn = "arn:aws:execute-api:eu-west-1:999967859851:aqnku8akd0/*/*/*"
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


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.9 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lambda_alias.no_refresh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_alias) | resource |
| [aws_lambda_alias.with_refresh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_alias) | resource |
| [aws_lambda_event_source_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping) | resource |
| [aws_lambda_function_event_invoke_config.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_event_invoke_config) | resource |
| [aws_lambda_permission.qualified_alias_triggers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.version_triggers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_alias.existing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lambda_alias) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_triggers"></a> [allowed\_triggers](#input\_allowed\_triggers) | Map of allowed triggers to create Lambda permissions | `map(any)` | `{}` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls whether resources should be created | `bool` | `true` | no |
| <a name="input_create_async_event_config"></a> [create\_async\_event\_config](#input\_create\_async\_event\_config) | Controls whether async event configuration for Lambda Function/Alias should be created | `bool` | `false` | no |
| <a name="input_create_qualified_alias_allowed_triggers"></a> [create\_qualified\_alias\_allowed\_triggers](#input\_create\_qualified\_alias\_allowed\_triggers) | Whether to allow triggers on qualified alias | `bool` | `true` | no |
| <a name="input_create_qualified_alias_async_event_config"></a> [create\_qualified\_alias\_async\_event\_config](#input\_create\_qualified\_alias\_async\_event\_config) | Whether to allow async event configuration on qualified alias | `bool` | `true` | no |
| <a name="input_create_version_allowed_triggers"></a> [create\_version\_allowed\_triggers](#input\_create\_version\_allowed\_triggers) | Whether to allow triggers on version of Lambda Function used by alias (this will revoke permissions from previous version because Terraform manages only current resources) | `bool` | `true` | no |
| <a name="input_create_version_async_event_config"></a> [create\_version\_async\_event\_config](#input\_create\_version\_async\_event\_config) | Whether to allow async event configuration on version of Lambda Function used by alias (this will revoke permissions from previous version because Terraform manages only current resources) | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the alias. | `string` | `""` | no |
| <a name="input_destination_on_failure"></a> [destination\_on\_failure](#input\_destination\_on\_failure) | Amazon Resource Name (ARN) of the destination resource for failed asynchronous invocations | `string` | `null` | no |
| <a name="input_destination_on_success"></a> [destination\_on\_success](#input\_destination\_on\_success) | Amazon Resource Name (ARN) of the destination resource for successful asynchronous invocations | `string` | `null` | no |
| <a name="input_event_source_mapping"></a> [event\_source\_mapping](#input\_event\_source\_mapping) | Map of event source mapping | `any` | `{}` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | The function ARN of the Lambda function for which you want to create an alias. | `string` | `""` | no |
| <a name="input_function_version"></a> [function\_version](#input\_function\_version) | Lambda function version for which you are creating the alias. Pattern: ($LATEST\|[0-9]+). | `string` | `""` | no |
| <a name="input_maximum_event_age_in_seconds"></a> [maximum\_event\_age\_in\_seconds](#input\_maximum\_event\_age\_in\_seconds) | Maximum age of a request that Lambda sends to a function for processing in seconds. Valid values between 60 and 21600. | `number` | `null` | no |
| <a name="input_maximum_retry_attempts"></a> [maximum\_retry\_attempts](#input\_maximum\_retry\_attempts) | Maximum number of times to retry when the function returns an error. Valid values between 0 and 2. Defaults to 2. | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the alias you are creating. | `string` | `""` | no |
| <a name="input_refresh_alias"></a> [refresh\_alias](#input\_refresh\_alias) | Whether to refresh function version used in the alias. Useful when using this module together with external tool do deployments (eg, AWS CodeDeploy). | `bool` | `true` | no |
| <a name="input_routing_additional_version_weights"></a> [routing\_additional\_version\_weights](#input\_routing\_additional\_version\_weights) | A map that defines the proportion of events that should be sent to different versions of a lambda function. | `map(number)` | `{}` | no |
| <a name="input_use_existing_alias"></a> [use\_existing\_alias](#input\_use\_existing\_alias) | Whether to manage existing alias instead of creating a new one. Useful when using this module together with external tool do deployments (eg, AWS CodeDeploy). | `bool` | `false` | no |

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
<!-- END_TF_DOCS -->

## Authors

Module managed by [Anton Babenko](https://github.com/antonbabenko). Check out [serverless.tf](https://serverless.tf) to learn more about doing serverless with Terraform.

Please reach out to [Betajob](https://www.betajob.com/) if you are looking for commercial support for your Terraform, AWS, or serverless project.


## License

Apache 2 Licensed. See LICENSE for full details.
