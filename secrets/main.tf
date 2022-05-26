terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.2.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
  }
}
