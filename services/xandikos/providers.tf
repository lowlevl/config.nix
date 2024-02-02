terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.25.2"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}
