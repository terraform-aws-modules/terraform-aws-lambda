# Build Docker Image module

Terraform module that builds Docker image from `Dockerfile` and pushes it to ECR repository. Lambda can deploy container images from private ECR.

This Terraform module is the part of [serverless.tf framework](https://github.com/antonbabenko/serverless.tf), which aims to simplify all operations when working with the serverless in Terraform.

## Usage

### Complete example of Lambda Function deployment via AWS CodeDeploy

```hcl
module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name  = "my-lambda1"
  create_package = false

  image_uri    = module.docker_image.image_uri
  package_type = "Image"
}

module "docker_image" {
  source = "terraform-aws-modules/lambda/aws//modules/docker-build"

  create_ecr_repo = true
  ecr_repo        = "my-cool-ecr-repo"
  image_tag       = "1.0"
  source_path     = "context"
}
```

## Examples

* [Container Image](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/examples/container-image) - Creates Docker Image and deploy Lambda Function using it.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.35 |
| <a name="requirement_docker"></a> [docker](#requirement\_docker) | >= 2.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.35 |
| <a name="provider_docker"></a> [docker](#provider\_docker) | >= 2.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [docker_registry_image.this](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/registry_image) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_ecr_authorization_token.token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_authorization_token) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_ecr_repo"></a> [create\_ecr\_repo](#input\_create\_ecr\_repo) | Controls whether ECR repository for Lambda image should be created | `bool` | `false` | no |
| <a name="input_docker_file_path"></a> [docker\_file\_path](#input\_docker\_file\_path) | Path to Dockerfile in source package | `string` | `"Dockerfile"` | no |
| <a name="input_ecr_repo"></a> [ecr\_repo](#input\_ecr\_repo) | Name of ECR repository to use or to create | `string` | `null` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Image tag to use. If not specified current timestamp in format 'YYYYMMDDhhmmss' will be used. This can lead to unnecessary rebuilds. | `string` | `null` | no |
| <a name="input_source_path"></a> [source\_path](#input\_source\_path) | Path to folder containing application code | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_image_uri"></a> [image\_uri](#output\_image\_uri) | The ECR image URI for deploying lambda |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Anton Babenko](https://github.com/antonbabenko). Check out [serverless.tf](https://serverless.tf) to learn more about doing serverless with Terraform.

Please reach out to [Betajob](https://www.betajob.com/) if you are looking for commercial support for your Terraform, AWS, or serverless project.


## License

Apache 2 Licensed. See LICENSE for full details.
