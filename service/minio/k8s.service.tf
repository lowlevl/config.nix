resource "kubernetes_service_v1" "minio" {
  metadata {
    name      = "minio"
    namespace = kubernetes_namespace_v1.self.metadata.0.name
  }

  spec {
    selector = {
      provides = kubernetes_deployment_v1.minio.spec.0.selector.0.match_labels.provides
    }

    port {
      port        = var.port
      target_port = "s3"
    }

    type = "LoadBalancer"
  }
}
