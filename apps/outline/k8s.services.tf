resource "kubernetes_service_v1" "wiki" {
  metadata {
    name      = "wiki"
    namespace = kubernetes_namespace_v1.self.metadata.0.name
  }

  spec {
    selector = {
      provides = kubernetes_deployment_v1.self.spec.0.selector.0.match_labels.provides
    }

    port {
      port        = var.port
      target_port = "wiki"
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_service_v1" "redis" {
  metadata {
    name      = "redis"
    namespace = kubernetes_namespace_v1.self.metadata.0.name
  }

  spec {
    selector = {
      provides = kubernetes_deployment_v1.redis.spec.0.selector.0.match_labels.provides
    }

    port {
      port        = 6379
      target_port = "redis"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service_v1" "postgres" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace_v1.self.metadata.0.name
  }

  spec {
    selector = {
      provides = kubernetes_deployment_v1.postgres.spec.0.selector.0.match_labels.provides
    }

    port {
      port        = 5432
      target_port = "postgres"
    }

    type = "ClusterIP"
  }
}
