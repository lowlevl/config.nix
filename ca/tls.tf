resource "tls_private_key" "ca" {
  algorithm = var.algorithm
  rsa_bits  = var.bits
}

resource "tls_self_signed_cert" "ca" {
  is_ca_certificate     = true
  private_key_pem       = tls_private_key.ca.private_key_pem
  validity_period_hours = var.validity
  allowed_uses = [
    "cert_signing",
    "key_encipherment",
    "digital_signature",
  ]

  subject {
    organization = var.org
    common_name  = var.cn
  }
}

resource "local_file" "ca" {
  filename        = var.path != null ? var.path : "${path.root}/ca.crt"
  content         = tls_self_signed_cert.ca.cert_pem
  file_permission = "0644"
}
