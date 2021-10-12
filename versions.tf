terraform {
  required_version = ">= 0.12.31"

  required_providers {
    aws      = ">= 3.61"
    external = ">= 1"
    local    = ">= 1"
    null     = ">= 2"
  }
}
