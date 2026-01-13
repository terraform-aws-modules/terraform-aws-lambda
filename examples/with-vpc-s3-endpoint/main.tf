provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

data "aws_region" "current" {}

################################################################################
# Lambda Module
################################################################################

module "lambda_s3_write" {
  source = "../../"

  description = "Lambda demonstrating writes to an S3 bucket from within a VPC without Internet access"

  function_name = random_pet.this.id
  handler       = "index.lambda_handler"
  runtime       = "python3.12"

  source_path = "${path.module}/../fixtures/python-app2"

  environment_variables = {
    BUCKET_NAME = module.s3_bucket.s3_bucket_id
    REGION_NAME = data.aws_region.current.region
  }

  # Let the module create a role for us
  create_role                   = true
  attach_cloudwatch_logs_policy = true
  attach_network_policy         = true

  # There's no need to attach any extra permission for S3 writes as that's added by the bucket policy when a session is created
  # See https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html

  vpc_security_group_ids = [module.security_group_lambda.security_group_id]
  vpc_subnet_ids         = module.vpc.intra_subnets

  tags = {
    Module = "lambda_s3_write"
  }
}

################################################################################
# Extra Resources
################################################################################

resource "random_pet" "this" {
  length = 2
}

data "aws_ec2_managed_prefix_list" "this" {
  name = "com.amazonaws.${data.aws_region.current.region}.s3"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = random_pet.this.id
  cidr = "10.0.0.0/16"

  azs = ["${data.aws_region.current.region}a", "${data.aws_region.current.region}b", "${data.aws_region.current.region}c"]

  # Intra subnets are designed to have no Internet access via NAT Gateway.
  intra_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  intra_dedicated_network_acl = true
  intra_inbound_acl_rules = concat(
    # NACL rule for local traffic
    [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_block  = "10.0.0.0/16"
      },
    ],
    # NACL rules for the response traffic from addresses in the AWS S3 prefix list
    [for k, v in zipmap(
      range(length(data.aws_ec2_managed_prefix_list.this.entries[*].cidr)),
      data.aws_ec2_managed_prefix_list.this.entries[*].cidr
      ) :
      {
        rule_number = 200 + k
        rule_action = "allow"
        from_port   = 1024
        to_port     = 65535
        protocol    = "tcp"
        cidr_block  = v
      }
    ]
  )
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 5.0"

  vpc_id = module.vpc.vpc_id

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = module.vpc.intra_route_table_ids
      policy          = data.aws_iam_policy_document.endpoint.json
    }
  }
}

data "aws_iam_policy_document" "endpoint" {
  statement {
    sid = "RestrictBucketAccessToIAMRole"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${module.s3_bucket.s3_bucket_arn}/*",
    ]

    # See https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints-s3.html#edit-vpc-endpoint-policy-s3
    condition {
      test     = "ArnEquals"
      variable = "aws:PrincipalArn"
      values   = [module.lambda_s3_write.lambda_role_arn]
    }
  }
}

module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 1.0"

  description = "S3 encryption key"

  # Grants
  grants = {
    lambda = {
      grantee_principal = module.lambda_s3_write.lambda_role_arn
      operations = [
        "GenerateDataKey",
      ]
    }
  }
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket_prefix = "${random_pet.this.id}-"
  force_destroy = true

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  # Bucket policy
  attach_policy = true
  policy        = data.aws_iam_policy_document.bucket.json

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = module.kms.key_id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

data "aws_iam_policy_document" "bucket" {
  statement {
    sid = "RestrictBucketAccessToIAMRole"

    principals {
      type        = "AWS"
      identifiers = [module.lambda_s3_write.lambda_role_arn]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${module.s3_bucket.s3_bucket_arn}/*",
    ]
  }
}

module "security_group_lambda" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = random_pet.this.id
  description = "Security Group for Lambda Egress"

  vpc_id = module.vpc.vpc_id

  egress_cidr_blocks      = []
  egress_ipv6_cidr_blocks = []

  # Prefix list ids to use in all egress rules in this module
  egress_prefix_list_ids = [module.vpc_endpoints.endpoints["s3"]["prefix_list_id"]]

  egress_rules = ["https-443-tcp"]
}
