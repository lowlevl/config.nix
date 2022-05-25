resource "kubernetes_secret_v1" "tls" {
  type = "kubernetes.io/tls"
  data = {
    "tls.crt" = file(var.ssl_cert_path)
    "tls.key" = file(var.ssl_key_path)
  }

  metadata {
    name      = "tls"
    namespace = kubernetes_namespace_v1.self.metadata.0.name
  }
}

resource "random_uuid" "access_key_id" {
  lifecycle {
    prevent_destroy = true
  }
}

resource "random_password" "secret_access_key" {
  lifecycle {
    prevent_destroy = true
  }

  keepers = {
    uuid = random_uuid.access_key_id.result
  }

  length           = 48
  lower            = false
  min_special      = 1
  override_special = "/"
}

resource "kubernetes_secret_v1" "credentials" {
  data = {
    "ACCESS_KEY_ID"     = random_uuid.access_key_id.result
    "SECRET_ACCESS_KEY" = random_password.secret_access_key.result
  }

  metadata {
    name      = "credentials"
    namespace = kubernetes_namespace_v1.self.metadata.0.name
  }
}
