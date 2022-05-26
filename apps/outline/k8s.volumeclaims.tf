resource "kubernetes_persistent_volume_claim_v1" "database" {
  metadata {
    name      = "database"
    namespace = kubernetes_namespace_v1.self.metadata.0.name
  }

  spec {
    access_modes = ["ReadWriteMany"]

    resources {
      requests = {
        storage = "2Gi"
      }
    }

    volume_name = var.volume.metadata.0.name
  }
}
