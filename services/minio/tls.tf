module "cert" {
  source = "../../ca/cert"

  from    = var.ca
  cn      = "minio.${var.ca.output.subject.0.organization}"
  domains = ["localhost", var.node.hostname] # MinIO requires `localhost` as a SAN
}

resource "kubernetes_secret_v1" "tls" {
  metadata {
    name      = "minio-tls"
    namespace = local.namespace
  }

  type = "kubernetes.io/tls"
  data = {
    "tls.crt" = module.cert.crt
    "tls.key" = module.cert.key
    "ca.crt"  = var.ca.output.cert_pem
  }
}
