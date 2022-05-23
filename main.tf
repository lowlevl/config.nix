terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"
    }

    remote = {
      source  = "tenstad/remote"
      version = "0.0.24"
    }

    # minio = {
    #   source  = "aminueza/minio"
    #   version = "1.5.2"
    # }
  }
}

provider "remote" {
  conn {
    user  = var.ssh["user"]
    host  = var.ssh["host"]
    port  = var.ssh["port"]
    agent = true
  }
}

provider "docker" {
  host = "ssh://${var.ssh["user"]}@${var.ssh["host"]}:${var.ssh["port"]}"
}

module "minio" {
  source = "./modules/minio"

  port              = 5303
  user              = var.minio-user
  data-mount        = "${var.minio-dir}/data"
  certs-mount       = "${var.minio-dir}/certs"
  access-key-id     = var.minio-access-key-id
  secret-access-key = var.minio-secret-access-key
}

resource "remote_file" "minio-ssl-cert" {
  content     = file(var.minio-ssl-cert-path)
  path        = "${var.minio-dir}/certs/public.crt"
  permissions = "0444"
}

resource "remote_file" "minio-ssl-key" {
  content     = file(var.minio-ssl-key-path)
  path        = "${var.minio-dir}/certs/private.key"
  permissions = "0400"
}
