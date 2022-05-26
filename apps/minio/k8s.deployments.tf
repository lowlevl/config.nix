resource "kubernetes_deployment_v1" "self" {
  metadata {
    name      = "self"
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
          name  = "self"
          image = "minio/minio:RELEASE.2022-05-26T05-48-41Z"
          args  = ["server", "/storage", "--certs-dir", "/certs"]

          env {
            name = "MINIO_ROOT_USER"

            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.credentials.metadata.0.name
                key  = "ACCESS_KEY_ID"
              }
            }
          }

          env {
            name = "MINIO_ROOT_PASSWORD"

            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.credentials.metadata.0.name
                key  = "SECRET_ACCESS_KEY"
              }
            }
          }

          env {
            name  = "MINIO_BROWSER"
            value = "off"
          }

          volume_mount {
            mount_path = "/storage"
            name       = "storage"
          }

          volume_mount {
            mount_path = "/certs"
            name       = "certs"
            read_only  = true
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

            initial_delay_seconds = 30
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

            initial_delay_seconds = 30
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
            claim_name = kubernetes_persistent_volume_claim_v1.storageclaim.metadata.0.name
          }
        }

        volume {
          name = "certs"

          secret {
            secret_name = kubernetes_secret_v1.tls.metadata.0.name

            items {
              key  = "tls.crt"
              mode = "0444"
              path = "public.crt"
            }

            items {
              key  = "tls.key"
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
