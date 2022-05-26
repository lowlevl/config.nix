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

locals {
  affinity = {
    minio = local.nodes["d3r.internal"]
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "minio" {
  minio_server     = "${local.affinity.minio.ip}:30001"
  minio_access_key = module.secrets.minio.ACCESS_KEY_ID
  minio_secret_key = module.secrets.minio.SECRET_ACCESS_KEY
  minio_ssl        = true
  minio_cert_file  = module.secrets.ca.path
}

module "secrets" {
  source = "./secrets"

  minio = {
    ip        = [local.affinity.minio.ip]
    hostnames = local.affinity.minio.hostnames
  }
}

module "minio" {
  source = "./apps/minio"

  nodes  = local.affinity.minio.hostnames
  port   = 30001
  volume = kubernetes_persistent_volume_v1.minio_volume

  credentials = {
    ACCESS_KEY_ID     = module.secrets.minio.ACCESS_KEY_ID
    SECRET_ACCESS_KEY = module.secrets.minio.SECRET_ACCESS_KEY
  }
  ssl = module.secrets.minio.ssl
}

# module "outline" {
#   source = "./apps/outline"

#   port   = 30002
#   volume = kubernetes_persistent_volume_v1.outline_volume
# }
