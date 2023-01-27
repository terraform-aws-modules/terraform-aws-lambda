terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.22"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.12, < 3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 2.0"
    }
  }
}
