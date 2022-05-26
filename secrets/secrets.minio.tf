locals {
  dns = ["d3r.internal"]
  ip  = ["10.0.9.1"]
}

resource "random_uuid" "minio_access_key_id" {}

resource "random_password" "minio_secret_access_key" {
  keepers = {
    uuid = random_uuid.minio_access_key_id.result
  }

  length           = 48
  lower            = false
  min_special      = 1
  override_special = "/"
}

resource "tls_private_key" "minio_ssl" {
  algorithm   = tls_private_key.ca.algorithm
  ecdsa_curve = tls_private_key.ca.ecdsa_curve
}

resource "tls_cert_request" "minio_ssl" {
  private_key_pem = tls_private_key.minio_ssl.private_key_pem
  dns_names       = local.dns
  ip_addresses    = local.ip

  subject {
    organization = tls_self_signed_cert.ca.subject.0.organization
    common_name  = local.dns.0
  }
}

resource "tls_locally_signed_cert" "minio_ssl" {
  cert_request_pem = tls_cert_request.minio_ssl.cert_request_pem

  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 1 * 8760 # 1 year
  allowed_uses = [
    "key_encipherment",
    "digital_signature"
  ]
}
