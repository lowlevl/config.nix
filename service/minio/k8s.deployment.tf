resource "kubernetes_deployment_v1" "minio" {
  metadata {
    name      = "minio"
    namespace = kubernetes_namespace_v1.self.metadata.0.name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        provides = "minio"
      }
    }

    template {
      metadata {
        labels = {
          provides = "minio"
        }
      }

      spec {
        container {
          image = "minio/minio:latest"
          name  = "minio"
          args  = ["server", "/storage", "--certs-dir", "/certs"]

          env {
            name = "MINIO_ROOT_USER"

            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.access_key_id.metadata.0.name
                key  = "value"
              }
            }
          }

          env {
            name = "MINIO_ROOT_PASSWORD"

            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.secret_access_key.metadata.0.name
                key  = "value"
              }
            }
          }

          volume_mount {
            mount_path = "/storage"
            name       = "storage"
          }

          volume_mount {
            mount_path = "/certs"
            name       = "certs"
          }

          volume_mount {
            mount_path = "/certs/CAs"
            name       = "ca"
          }

          port {
            name           = "s3"
            protocol       = "TCP"
            container_port = 9000
          }

          liveness_probe {
            http_get {
              scheme = "HTTPS"
              path   = "/minio/health/live"
              port   = 9000
            }

            initial_delay_seconds = 120
            period_seconds        = 30
            timeout_seconds       = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              scheme = "HTTPS"
              path   = "/minio/health/ready"
              port   = 9000
            }

            initial_delay_seconds = 120
            period_seconds        = 15
            timeout_seconds       = 10
            success_threshold     = 1
            failure_threshold     = 3
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512M"
            }

            requests = {
              cpu    = "10m"
              memory = "128M"
            }
          }
        }

        volume {
          name = "storage"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.minio.metadata.0.name
          }
        }

        volume {
          name = "certs"

          secret {
            secret_name = kubernetes_secret_v1.certificates.metadata.0.name

            items {
              key  = "public.crt"
              mode = "0444"
              path = "public.crt"
            }

            items {
              key  = "private.key"
              mode = "0400"
              path = "private.key"
            }
          }
        }

        volume {
          name = "ca"

          empty_dir {}
        }

        restart_policy = "Always"
      }
    }
  }
}
