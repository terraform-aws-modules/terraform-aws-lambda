terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.63"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.0"
    }
  }
}
