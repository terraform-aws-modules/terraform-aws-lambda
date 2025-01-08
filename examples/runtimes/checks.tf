locals {
  successful_response_keyword = "serverless.tf"
}

data "http" "this" {
  for_each = {
    rust = module.rust_lambda_function.lambda_function_url,
    go   = module.go_lambda_function.lambda_function_url,
  }

  url = each.value

  lifecycle {
    postcondition {
      condition     = length(regexall(local.successful_response_keyword, self.response_body)) > 0
      error_message = "${each.key}: ${local.successful_response_keyword} should be in the response."
    }
  }
}

# I don't know how to make Java21 example to work with Lambda Function URL, so using Lambda Function invocation instead
data "aws_lambda_invocation" "this" {
  for_each = {
    java21 = module.java21_lambda_function.lambda_function_name,
  }

  function_name = each.value

  input = jsonencode({})

  lifecycle {
    postcondition {
      condition     = length(regexall(local.successful_response_keyword, jsondecode(self.result))) > 0
      error_message = "${each.key}: ${local.successful_response_keyword} should be in the response."
    }
  }
}
