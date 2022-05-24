terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.2.0"
    }
  }

  required_version = ">= 1.1"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

module "minio" {
  source = "./apps/minio"

  ssl_cert_path = var.minio_ssl_cert_path
  ssl_key_path  = var.minio_ssl_key_path
  port          = 30001
}
