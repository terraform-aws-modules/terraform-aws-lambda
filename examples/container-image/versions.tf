terraform {
  required_version = ">= 0.12.6"

  required_providers {
    aws    = ">= 3.19"
    random = ">= 2"

    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.8.0"
    }
  }
}
