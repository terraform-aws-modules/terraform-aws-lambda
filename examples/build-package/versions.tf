terraform {
  required_version = ">= 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.27"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.0"
    }
  }
}
