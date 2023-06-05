terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.33"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4"
    }
  }
}
