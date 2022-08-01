terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws      = ">= 3.61"
    external = ">= 1"
    local    = ">= 1"
    null     = ">= 2"
  }
}
