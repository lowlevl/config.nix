resource "random_uuid" "access_key_id" {}

resource "kubernetes_secret_v1" "access_key_id" {
  data = {
    value = random_uuid.access_key_id.result
  }

  metadata {
    name      = "access-key-id"
    namespace = kubernetes_namespace_v1.self.metadata[0].name
  }
}

resource "random_password" "secret_access_key" {
  length           = 48
  lower            = false
  min_special      = 1
  override_special = "/"
}

resource "kubernetes_secret_v1" "secret_access_key" {
  data = {
    value = random_password.secret_access_key.result
  }

  metadata {
    name      = "secret-access-key"
    namespace = kubernetes_namespace_v1.self.metadata[0].name
  }
}

resource "kubernetes_secret_v1" "certificates" {
  data = {
    "public.crt"  = file(var.ssl_cert_path)
    "private.key" = file(var.ssl_key_path)
  }

  metadata {
    name      = "certificates"
    namespace = kubernetes_namespace_v1.self.metadata[0].name
  }
}
