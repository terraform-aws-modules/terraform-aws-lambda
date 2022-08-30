terraform {
  required_version = ">= 1.1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.22.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.12"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.0"
    }
  }
}
