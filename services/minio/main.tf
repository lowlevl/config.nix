locals {
  namespace = "minio"
}

resource "helm_release" "release" {
  name       = "minio"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "minio"
  version    = "12.1.10"

  create_namespace = true
  namespace        = local.namespace

  set {
    name  = "image.tag"
    value = "2023.2.27-debian-11-r1"
  }

  set {
    name  = "mode"
    value = "standalone"
  }
  set {
    name  = "disableWebUI"
    value = true
  }

  set {
    name  = "tls.enabled"
    value = true
  }
  set {
    name  = "tls.existingSecret"
    value = kubernetes_secret_v1.tls.metadata.0.name
  }

  set {
    name  = "auth.forceNewKeys"
    value = true
  }
  set {
    name  = "auth.rootUser"
    value = random_string.access_key_id.result
  }
  set_sensitive {
    name  = "auth.rootPassword"
    value = random_password.secret_access_key.result
  }

  set {
    name  = "service.type"
    value = "NodePort"
  }
  set {
    name  = "service.nodePorts.api"
    value = var.service.port
  }

  set {
    name  = "persistence.size"
    value = "128Gi"
  }
}
