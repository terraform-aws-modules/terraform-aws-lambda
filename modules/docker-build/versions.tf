terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = ">= 3.35"
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.8.0"
    }
  }
}
