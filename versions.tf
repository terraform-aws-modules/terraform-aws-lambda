terraform {
  required_version = ">= 0.12.6, < 0.14"

  required_providers {
    aws      = ">= 2.67, < 4.0"
    external = "~> 1"
    local    = "~> 1"
    random   = "~> 2"
    null     = "~> 2"
  }
}
