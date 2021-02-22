terraform {
  required_version = ">= 0.13"

  required_providers {
    aws      = ">= 3.19"
    external = ">= 1"
    local    = ">= 1"
    random   = ">= 2"
    null     = ">= 2"
  }
}
