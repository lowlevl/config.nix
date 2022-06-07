locals {
  database = {
    username = "outline"
    hostname = kubernetes_service_v1.postgres.spec.0.cluster_ip
    port     = kubernetes_service_v1.postgres.spec.0.port.0.port
    database = "outline"
  }
  redis = {
    hostname = kubernetes_service_v1.redis.spec.0.cluster_ip
    port     = kubernetes_service_v1.redis.spec.0.port.0.port
  }
}

resource "kubernetes_secret_v1" "outline" {
  data = {
    SECRET_KEY   = var.secrets.SECRET_KEY
    UTILS_SECRET = var.secrets.UTILS_SECRET

    DATABASE_URL = "postgres://${local.database.username}@${local.database.hostname}:${local.database.port}/${local.database.database}"
    REDIS_URL    = "redis://${local.redis.hostname}:${local.redis.port}"
  }
  immutable = true

  metadata {
    generate_name = "secrets-"
    namespace     = kubernetes_namespace_v1.self.metadata.0.name
  }
}

resource "kubernetes_secret_v1" "s3" {
  data = {
    AWS_ACCESS_KEY_ID     = minio_iam_user.self.name
    AWS_SECRET_ACCESS_KEY = minio_iam_user.self.secret
  }
  immutable = true

  metadata {
    generate_name = "s3-"
    namespace     = kubernetes_namespace_v1.self.metadata.0.name
  }
}

resource "kubernetes_secret_v1" "smtp" {
  data = {
    SMTP_USERNAME = var.secrets.SMTP_USERNAME
    SMTP_PASSWORD = var.secrets.SMTP_PASSWORD
  }
  immutable = true

  metadata {
    generate_name = "smtp-"
    namespace     = kubernetes_namespace_v1.self.metadata.0.name
  }
}
