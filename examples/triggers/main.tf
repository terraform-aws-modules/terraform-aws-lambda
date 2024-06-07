provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

##########################################
# Lambda Function (with various triggers)
##########################################

module "lambda_function" {
  source = "../../"

  function_name = "${random_pet.this.id}-lambda-triggers"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"
  publish       = true

  create_package         = false
  local_existing_package = "${path.module}/../fixtures/python-zip/existing_package.zip"

  allowed_triggers = {
    ScanAmiRule = {
      principal  = "events.amazonaws.com"
      source_arn = aws_cloudwatch_event_rule.scan_ami.arn
    }
  }
}

##################
# Extra resources
##################

resource "random_pet" "this" {
  length = 2
}

##################################
# Cloudwatch Events (EventBridge)
##################################
resource "aws_cloudwatch_event_rule" "scan_ami" {
  name          = "EC2CreateImageEvent"
  description   = "EC2 Create Image Event..."
  event_pattern = <<EOF
{
  "source": ["aws.ec2"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["ec2.amazonaws.com"],
    "eventName": ["CreateImage"]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "scan_ami_lambda_function" {
  rule = aws_cloudwatch_event_rule.scan_ami.name
  arn  = module.lambda_function.lambda_function_arn
}
