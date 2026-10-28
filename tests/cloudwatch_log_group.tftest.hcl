provider "aws" {
  region                      = "us-west-2"
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

mock_provider "external" {}
mock_provider "local" {}
mock_provider "null" {}

run "create_log_group_uses_bare_group_arn" {
  command = plan

  variables {
    function_name = "test"
    handler       = "index.handler"
    runtime       = "python3.12"

    create_package = false
    s3_existing_package = {
      bucket = "test-lambda-packages"
      key    = "test.zip"
    }
  }

  override_data {
    target = data.aws_caller_identity.current
    values = {
      account_id = "123456789012"
    }
  }

  override_data {
    target = data.aws_region.current
    values = {
      name   = "us-west-2"
      region = "us-west-2"
      id     = "us-west-2"
    }
  }

  override_data {
    target = data.aws_partition.current
    values = {
      partition  = "aws"
      dns_suffix = "amazonaws.com"
    }
  }

  override_data {
    target = data.aws_iam_policy_document.assume_role[0]
    values = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
    }
  }

  override_resource {
    target          = aws_cloudwatch_log_group.lambda[0]
    override_during = plan
    values = {
      arn  = "arn:aws:logs:us-west-2:123456789012:log-group:/aws/lambda/test:*"
      name = "/aws/lambda/test"
    }
  }

  assert {
    condition = (
      jsondecode(data.aws_iam_policy_document.logs[0].json).Statement[1].Action == "logs:CreateLogGroup" &&
      try(tolist(jsondecode(data.aws_iam_policy_document.logs[0].json).Statement[1].Resource), [jsondecode(data.aws_iam_policy_document.logs[0].json).Statement[1].Resource])[0] ==
      "arn:aws:logs:us-west-2:123456789012:log-group:/aws/lambda/test"
    )
    error_message = "CreateLogGroup must target the bare log group ARN"
  }

  assert {
    condition = (
      contains(tolist(jsondecode(data.aws_iam_policy_document.logs[0].json).Statement[0].Action), "logs:CreateLogStream") &&
      contains(tolist(jsondecode(data.aws_iam_policy_document.logs[0].json).Statement[0].Action), "logs:PutLogEvents") &&
      length(jsondecode(data.aws_iam_policy_document.logs[0].json).Statement[0].Resource) == 2 &&
      contains(
        tolist(jsondecode(data.aws_iam_policy_document.logs[0].json).Statement[0].Resource),
        "arn:aws:logs:us-west-2:123456789012:log-group:/aws/lambda/test:*:*:*"
      ) &&
      contains(
        tolist(jsondecode(data.aws_iam_policy_document.logs[0].json).Statement[0].Resource),
        "arn:aws:logs:us-west-2:123456789012:log-group:/aws/lambda/test:*:*"
      )
    )
    error_message = "The existing log-stream permissions must remain unchanged"
  }
}

run "create_log_group_permission_gate_is_preserved" {
  command = plan

  variables {
    function_name = "test"
    handler       = "index.handler"
    runtime       = "python3.12"

    create_package                     = false
    attach_create_log_group_permission = false
    s3_existing_package = {
      bucket = "test-lambda-packages"
      key    = "test.zip"
    }
  }

  override_data {
    target = data.aws_caller_identity.current
    values = {
      account_id = "123456789012"
    }
  }

  override_data {
    target = data.aws_region.current
    values = {
      name   = "us-west-2"
      region = "us-west-2"
      id     = "us-west-2"
    }
  }

  override_data {
    target = data.aws_partition.current
    values = {
      partition  = "aws"
      dns_suffix = "amazonaws.com"
    }
  }

  override_data {
    target = data.aws_iam_policy_document.assume_role[0]
    values = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
    }
  }

  override_resource {
    target          = aws_cloudwatch_log_group.lambda[0]
    override_during = plan
    values = {
      arn  = "arn:aws:logs:us-west-2:123456789012:log-group:/aws/lambda/test:*"
      name = "/aws/lambda/test"
    }
  }

  assert {
    condition     = length(jsondecode(data.aws_iam_policy_document.logs[0].json).Statement) == 1
    error_message = "Disabling attach_create_log_group_permission must suppress the extra grant"
  }
}

run "existing_log_group_gate_is_preserved" {
  command = plan

  variables {
    function_name = "test"
    handler       = "index.handler"
    runtime       = "python3.12"

    create_package                    = false
    use_existing_cloudwatch_log_group = true
    s3_existing_package = {
      bucket = "test-lambda-packages"
      key    = "test.zip"
    }
  }

  override_data {
    target = data.aws_caller_identity.current
    values = {
      account_id = "123456789012"
    }
  }

  override_data {
    target = data.aws_region.current
    values = {
      name   = "us-west-2"
      region = "us-west-2"
      id     = "us-west-2"
    }
  }

  override_data {
    target = data.aws_partition.current
    values = {
      partition  = "aws"
      dns_suffix = "amazonaws.com"
    }
  }

  override_data {
    target = data.aws_cloudwatch_log_group.lambda[0]
    values = {
      arn  = "arn:aws:logs:us-west-2:123456789012:log-group:/aws/lambda/test:*"
      name = "/aws/lambda/test"
    }
  }

  override_data {
    target = data.aws_iam_policy_document.assume_role[0]
    values = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
    }
  }

  assert {
    condition     = length(jsondecode(data.aws_iam_policy_document.logs[0].json).Statement) == 1
    error_message = "An existing log group must not receive a CreateLogGroup grant"
  }
}
