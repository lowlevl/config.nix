resource "kubernetes_secret_v1" "tls" {
  type = "kubernetes.io/tls"
  data = {
    "tls.crt" = var.ssl.crt
    "tls.key" = var.ssl.key
  }

  metadata {
    name      = "tls"
    namespace = kubernetes_namespace_v1.self.metadata.0.name
  }
}

resource "kubernetes_secret_v1" "credentials" {
  data = {
    "ACCESS_KEY_ID"     = var.credentials["ACCESS_KEY_ID"]
    "SECRET_ACCESS_KEY" = var.credentials["SECRET_ACCESS_KEY"]
  }

  metadata {
    name      = "credentials"
    namespace = kubernetes_namespace_v1.self.metadata.0.name
  }
}
