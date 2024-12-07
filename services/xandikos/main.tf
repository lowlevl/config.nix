resource "kubernetes_namespace_v1" "namespace" {
  metadata {
    name = "xandikos"
  }
}

resource "helm_release" "release" {
  name  = "xandikos"
  chart = "${path.module}/chart"

  dependency_update = true
  wait              = true

  namespace = kubernetes_namespace_v1.namespace.metadata[0].name

  set {
    name  = "image.tag"
    value = var.tag
  }

  set {
    name  = "persistence.size"
    value = "256Mi"
  }
  set {
    name  = "persistence.storageClass"
    value = "local-path"
  }

  set {
    name  = "ingress.hostname"
    value = var.hostname
  }

  set {
    name  = "ingress.tls"
    value = true
  }

  set {
    name  = "ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt-prod"
  }

  set {
    name = "ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.middlewares"
    value = join("\\,",
      [
        "default-https-redirect@kubernetescrd",
        "${kubernetes_manifest.middleware.object.metadata.namespace}-${kubernetes_manifest.middleware.object.metadata.name}@kubernetescrd"
    ])
  }
}
