terraform {
  required_version = ">= 0.12.26"

  required_providers {
    aws      = ">= 3.35"
    external = ">= 1"
    local    = ">= 1"
    random   = ">= 2"
    null     = ">= 2"
  }
}
