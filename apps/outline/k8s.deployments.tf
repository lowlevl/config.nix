resource "kubernetes_deployment_v1" "self" {
  metadata {
    name      = "self"
    namespace = kubernetes_namespace_v1.self.metadata.0.name
  }

  spec {
    replicas = 2

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
          image = "outlinewiki/outline:0.64.2"

          port {
            name           = "wiki"
            protocol       = "TCP"
            container_port = 3000
          }

          resources {
            limits = {
              cpu    = "200m"
              memory = "256M"
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
