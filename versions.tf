terraform {
  required_version = ">= 0.12.26"

  required_providers {
    aws      = ">= 3.43"
    external = ">= 1"
    local    = ">= 1"
    null     = ">= 2"
  }
}
