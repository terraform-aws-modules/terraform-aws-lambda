terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = { 
      source  = "hashicorp/aws"
      version = ">= 3.17"
    }
    archive_file = {
      source = "hashicorp/archive_file"
      version = ">= 2.2.0" 
    }
  }
}
