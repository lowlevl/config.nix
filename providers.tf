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

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "minio" {
  minio_server     = "${var.loadbalancer.ip}:${var.loadbalancer.services["minio"].port}"
  minio_access_key = module.secrets.minio.ACCESS_KEY_ID
  minio_secret_key = module.secrets.minio.SECRET_ACCESS_KEY
  minio_ssl        = true
  minio_cert_file  = module.secrets.ca.path
}
