terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.19"
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
