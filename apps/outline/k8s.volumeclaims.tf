resource "kubernetes_persistent_volume_claim_v1" "postgres" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace_v1.self.metadata.0.name
  }

  spec {
    access_modes = ["ReadWriteMany"]

    resources {
      requests = {
        storage = "8Gi"
      }
    }

    volume_name = var.volume.metadata.0.name
  }
}
