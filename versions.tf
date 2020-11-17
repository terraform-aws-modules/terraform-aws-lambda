terraform {
  required_version = ">= 0.12.6"

  required_providers {
    aws      = ">= 2.67"
    external = ">= 1"
    local    = ">= 1"
    random   = ">= 2"
    null     = ">= 2"
  }
}
