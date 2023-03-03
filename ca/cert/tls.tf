resource "tls_private_key" "private_key" {
  algorithm = var.from.ca.key_algorithm
  rsa_bits  = var.bits
}

resource "tls_cert_request" "cert_request" {
  private_key_pem = tls_private_key.private_key.private_key_pem
  ip_addresses    = var.addresses
  dns_names       = var.domains

  subject {
    organization = var.from.ca.subject.0.organization
    common_name  = var.cn
  }
}

resource "tls_locally_signed_cert" "cert" {
  cert_request_pem = tls_cert_request.cert_request.cert_request_pem

  ca_private_key_pem = var.from.ca.private_key_pem
  ca_cert_pem        = var.from.ca.cert_pem

  validity_period_hours = var.validity
  allowed_uses = [
    "key_encipherment",
    "digital_signature"
  ]
}
