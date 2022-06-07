terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "3.4.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.2.0"
    }
  }
}
