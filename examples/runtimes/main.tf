provider "aws" {
  region = "eu-west-1"
}

module "rust_lambda_function" {
  source = "../../"

  function_name = "${random_pet.this.id}-rust"

  attach_cloudwatch_logs_policy     = false
  cloudwatch_logs_retention_in_days = 1

  create_lambda_function_url = true

  handler       = "bootstrap"
  runtime       = "provided.al2023"
  architectures = ["arm64"] # x86_64 (empty); arm64 (cargo lambda build --arm64)

  trigger_on_package_timestamp = false

  source_path = [
    {
      path = "${path.module}/../fixtures/runtimes/rust"
      commands = [
        # https://www.cargo-lambda.info/
        "cargo lambda build --release --arm64",
        "cd target/lambda/rust-app1",
        ":zip",
      ]
      patterns = [
        "!.*",
        "bootstrap",
      ]
    }
  ]
}

module "go_lambda_function" {
  source = "../../"

  function_name = "${random_pet.this.id}-go"

  attach_cloudwatch_logs_policy     = false
  cloudwatch_logs_retention_in_days = 1

  create_lambda_function_url = true

  handler       = "bootstrap"
  runtime       = "provided.al2023"
  architectures = ["arm64"] # x86_64 (GOARCH=amd64); arm64 (GOARCH=arm64)

  trigger_on_package_timestamp = false

  source_path = [
    {
      path = "${path.module}/../fixtures/runtimes/go"
      commands = [
        "GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -o bootstrap main.go",
        ":zip",
      ]
      patterns = [
        "!.*",
        "bootstrap",
      ]
    }
  ]
}

module "java21_lambda_function" {
  source = "../../"

  function_name = "${random_pet.this.id}-java21"

  attach_cloudwatch_logs_policy     = false
  cloudwatch_logs_retention_in_days = 1

  handler       = "example.Handler"
  runtime       = "java21"
  architectures = ["arm64"] # x86_64 or arm64
  timeout       = 30

  trigger_on_package_timestamp = false

  source_path = [
    {
      path = "${path.module}/../fixtures/runtimes/java21"
      commands = [
        "gradle build -i",
        "cd build/output",
        ":zip",
      ]
    }
  ]
}

resource "random_pet" "this" {
  length = 2
}
