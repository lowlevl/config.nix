resource "kubernetes_persistent_volume_claim_v1" "minio" {
  metadata {
    name      = "minio"
    namespace = kubernetes_namespace_v1.self.metadata.0.name
  }

  spec {
    access_modes = ["ReadWriteMany"]

    resources {
      requests = {
        storage = "2Gi"
      }
    }

    volume_name = kubernetes_persistent_volume_v1.minio.metadata.0.name
  }
}

resource "kubernetes_persistent_volume_v1" "minio" {
  metadata {
    name = "minio"
  }

  spec {
    access_modes = ["ReadWriteMany"]
    capacity = {
      storage = "64Gi"
    }

    storage_class_name = "local-path"

    persistent_volume_source {
      local {
        path = "/srv/k3s/minio"
      }
    }

    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "kubernetes.io/hostname"
            operator = "In"
            values   = ["d3r.internal"]
          }
        }
      }
    }
  }
}
