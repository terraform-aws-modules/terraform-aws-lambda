terraform {
  required_version = ">= 1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.63"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0"
    }
  }
}
