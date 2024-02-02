resource "random_password" "password" {
  length  = 48
  special = false
}

resource "kubernetes_secret_v1" "secret" {
  metadata {
    namespace = kubernetes_namespace_v1.namespace.metadata[0].name
    name      = "auth-secret"
  }

  data = {
    username = var.username
    password = random_password.password.result
  }

  type = "kubernetes.io/basic-auth"
}

resource "kubernetes_manifest" "middleware" {
  manifest = {
    "apiVersion" = "traefik.io/v1alpha1"
    "kind"       = "Middleware"
    "metadata" = {
      "namespace" = kubernetes_namespace_v1.namespace.metadata[0].name
      "name"      = "basic-auth"
    }
    "spec" = {
      "basicAuth" = {
        "secret"       = kubernetes_secret_v1.secret.metadata[0].name
        "realm"        = "You shouldn't be there, actually >:)"
        "removeHeader" = true
      }
    }
  }
}
