terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
  }

  required_version = ">= 1.1"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

module "secrets" {
  source = "./secrets"
}

module "minio" {
  source = "./apps/minio"

  port   = 30001
  volume = kubernetes_persistent_volume_v1.minio_volume

  credentials = {
    ACCESS_KEY_ID     = module.secrets.minio.ACCESS_KEY_ID
    SECRET_ACCESS_KEY = module.secrets.minio.SECRET_ACCESS_KEY
  }
  ssl = module.secrets.minio.ssl
}
