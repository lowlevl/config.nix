resource "kubernetes_deployment_v1" "self" {
  metadata {
    name      = "self"
    namespace = kubernetes_namespace_v1.self.metadata.0.name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        provides = "outline"
      }
    }

    template {
      metadata {
        labels = {
          provides = "outline"
        }
      }

      spec {
        container {
          name  = "self"
          image = "outlinewiki/outline:0.64.3"

          env {
            name  = "URL"
            value = var.secrets.URL
          }

          env {
            name = "SECRET_KEY"

            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.outline.metadata.0.name
                key  = "SECRET_KEY"
              }
            }
          }

          env {
            name = "UTILS_SECRET"

            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.outline.metadata.0.name
                key  = "UTILS_SECRET"
              }
            }
          }

          env {
            name = "REDIS_URL"

            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.outline.metadata.0.name
                key  = "REDIS_URL"
              }
            }
          }

          env {
            name = "DATABASE_URL"

            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.outline.metadata.0.name
                key  = "DATABASE_URL"
              }
            }
          }

          env {
            name  = "PGSSLMODE"
            value = "disable"
          }

          env {
            name  = "FORCE_HTTPS"
            value = "false"
          }

          env {
            name = "AWS_ACCESS_KEY_ID"

            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.s3.metadata.0.name
                key  = "AWS_ACCESS_KEY_ID"
              }
            }
          }

          env {
            name = "AWS_SECRET_ACCESS_KEY"

            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.s3.metadata.0.name
                key  = "AWS_SECRET_ACCESS_KEY"
              }
            }
          }

          env {
            name  = "AWS_REGION"
            value = "xx-xxxx-x"
          }

          env {
            name  = "AWS_S3_UPLOAD_BUCKET_URL"
            value = var.s3.endpoint
          }

          env {
            name  = "AWS_S3_UPLOAD_BUCKET_NAME"
            value = var.s3.bucket
          }

          env {
            name  = "AWS_S3_UPLOAD_MAX_SIZE"
            value = var.s3.max_size
          }

          env {
            name  = "SMTP_HOST"
            value = var.secrets.SMTP_HOST
          }

          env {
            name  = "SMTP_PORT"
            value = var.secrets.SMTP_PORT
          }

          env {
            name  = "SMTP_SECURE"
            value = var.secrets.SMTP_SECURE
          }

          env {
            name = "SMTP_USERNAME"

            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.smtp.metadata.0.name
                key  = "SMTP_USERNAME"
              }
            }
          }

          env {
            name = "SMTP_PASSWORD"

            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.smtp.metadata.0.name
                key  = "SMTP_PASSWORD"
              }
            }
          }

          env {
            name  = "SMTP_FROM_EMAIL"
            value = var.secrets.SMTP_FROM_EMAIL
          }

          env {
            name  = "SMTP_REPLY_EMAIL"
            value = var.secrets.SMTP_REPLY_EMAIL
          }

          port {
            name           = "wiki"
            protocol       = "TCP"
            container_port = 3000
          }

          resources {
            limits = {
              cpu    = "750m"
              memory = "512M"
            }

            requests = {
              cpu    = "10m"
              memory = "64M"
            }
          }
        }

        restart_policy = "Always"
      }
    }
  }
}

resource "kubernetes_deployment_v1" "redis" {
  metadata {
    name      = "redis"
    namespace = kubernetes_namespace_v1.self.metadata.0.name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        provides = "redis"
      }
    }

    template {
      metadata {
        labels = {
          provides = "redis"
        }
      }

      spec {
        container {
          name  = "redis"
          image = "redis:7.0"

          port {
            name           = "redis"
            protocol       = "TCP"
            container_port = 6379
          }

          liveness_probe {
            tcp_socket {
              port = 6379
            }

            initial_delay_seconds = 30
            period_seconds        = 30
            timeout_seconds       = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          readiness_probe {
            tcp_socket {
              port = 6379
            }

            initial_delay_seconds = 30
            period_seconds        = 15
            timeout_seconds       = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          resources {
            limits = {
              cpu    = "200m"
              memory = "512M"
            }

            requests = {
              cpu    = "10m"
              memory = "32M"
            }
          }
        }

        restart_policy = "Always"
      }
    }
  }
}

resource "kubernetes_deployment_v1" "postgres" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace_v1.self.metadata.0.name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        provides = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          provides = "postgres"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = "postgres:14.3"

          env {
            name  = "POSTGRES_USER"
            value = "outline"
          }

          env {
            name  = "POSTGRES_HOST_AUTH_METHOD"
            value = "trust"
          }

          volume_mount {
            mount_path = "/var/lib/postgresql/data"
            name       = "storage"
          }

          port {
            name           = "postgres"
            protocol       = "TCP"
            container_port = 5432
          }

          liveness_probe {
            tcp_socket {
              port = 5432
            }

            initial_delay_seconds = 30
            period_seconds        = 30
            timeout_seconds       = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          readiness_probe {
            tcp_socket {
              port = 5432
            }

            initial_delay_seconds = 30
            period_seconds        = 15
            timeout_seconds       = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          resources {
            limits = {
              cpu    = "200m"
              memory = "256M"
            }

            requests = {
              cpu    = "10m"
              memory = "32M"
            }
          }
        }

        volume {
          name = "storage"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.postgres.metadata.0.name
          }
        }

        restart_policy = "Always"
      }
    }
  }
}
