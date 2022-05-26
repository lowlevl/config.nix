resource "kubernetes_persistent_volume_v1" "minio_volume" {
  metadata {
    name = "volume.minio"
  }

  spec {
    access_modes = ["ReadWriteMany"]
    capacity = {
      storage = "256Gi"
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
            values   = local.affinity.minio.hostnames
          }
        }
      }
    }
  }
}
