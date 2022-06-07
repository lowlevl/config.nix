module "secrets" {
  source = "./secrets"

  minio = {
    ip        = [var.loadbalancer.ip]
    hostnames = []
  }
}

module "minio" {
  source = "./apps/minio"

  port   = var.loadbalancer.services["minio"].port
  volume = kubernetes_persistent_volume_v1.minio

  credentials = {
    ACCESS_KEY_ID     = module.secrets.minio.ACCESS_KEY_ID
    SECRET_ACCESS_KEY = module.secrets.minio.SECRET_ACCESS_KEY
  }
  tls = module.secrets.minio.tls
}

module "outline" {
  source = "./apps/outline"

  port   = var.loadbalancer.services["outline"].port
  volume = kubernetes_persistent_volume_v1.outline

  s3 = {
    endpoint = "${var.loadbalancer.services["minio"].scheme}://${var.loadbalancer.services["minio"].hostname}:${var.loadbalancer.services["minio"].port}"
    bucket   = "services.outline"
    max_size = 26214400
  }
  secrets = {
    URL = "${var.loadbalancer.services["outline"].scheme}://${var.loadbalancer.services["outline"].hostname}:${var.loadbalancer.services["outline"].port}"

    SECRET_KEY   = var.outline.SECRET_KEY
    UTILS_SECRET = module.secrets.outline.UTILS_SECRET

    SMTP_HOST        = var.outline.SMTP_HOST
    SMTP_PORT        = var.outline.SMTP_PORT
    SMTP_SECURE      = "true"
    SMTP_USERNAME    = var.outline.SMTP_USERNAME
    SMTP_PASSWORD    = var.outline.SMTP_PASSWORD
    SMTP_FROM_EMAIL  = var.outline.SMTP_FROM_EMAIL
    SMTP_REPLY_EMAIL = var.outline.SMTP_REPLY_EMAIL
  }
}
