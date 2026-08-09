# tests/create.tftest.hcl
#
# Regression test for https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/767
# Ensures terraform_data.package_filename_for_hash respects `create = false`
# and `ignore_source_code_hash = true`, instead of always being planned.

variables {
  putin_khuylo  = true
  function_name = "test-lambda-create-flag"
  handler       = "index.handler"
  runtime       = "python3.12"

  create_package        = false
  local_existing_package = "./examples/fixtures/python-zip/existing_package.zip"
}

# ---------------------------------------------------------------------------
# create = false -> no resources at all, including package_filename_for_hash
# ---------------------------------------------------------------------------
run "no_resources_when_create_is_false" {
  command = plan

  variables {
    create = false
  }

  assert {
    condition     = length(terraform_data.package_filename_for_hash) == 0
    error_message = "terraform_data.package_filename_for_hash should not be planned when create = false"
  }

  assert {
    condition     = length(aws_lambda_function.this) == 0
    error_message = "aws_lambda_function.this should not be planned when create = false"
  }
}

# ---------------------------------------------------------------------------
# create = true, ignore_source_code_hash = true -> hash resource still absent
# ---------------------------------------------------------------------------
run "no_hash_resource_when_ignore_source_code_hash_is_true" {
  command = plan

  variables {
    create                  = true
    ignore_source_code_hash = true
  }

  assert {
    condition     = length(terraform_data.package_filename_for_hash) == 0
    error_message = "terraform_data.package_filename_for_hash should not be planned when ignore_source_code_hash = true"
  }
}

# ---------------------------------------------------------------------------
# create = true, ignore_source_code_hash = false (default) -> resource present
# ---------------------------------------------------------------------------
run "hash_resource_present_when_create_is_true" {
  command = plan

  variables {
    create                  = true
    ignore_source_code_hash = false
  }

  assert {
    condition     = length(terraform_data.package_filename_for_hash) == 1
    error_message = "terraform_data.package_filename_for_hash should be planned when create = true and ignore_source_code_hash = false"
  }
}
