terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"
    }

    minio = {
      source  = "aminueza/minio"
      version = "1.5.2"
    }
  }

  required_version = ">= 1.1"
}
