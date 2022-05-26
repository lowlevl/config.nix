locals {
  algorithm = "RSA"
  bits      = 4096
  validity  = 3 * 8760 # 3 year

  org = "k3s Instance"
  cn  = "R0"
}

resource "tls_private_key" "ca" {
  algorithm = local.algorithm
  rsa_bits  = local.bits
}

resource "tls_self_signed_cert" "ca" {
  is_ca_certificate     = true
  private_key_pem       = tls_private_key.ca.private_key_pem
  validity_period_hours = local.validity
  allowed_uses = [
    "cert_signing",
    "key_encipherment",
    "digital_signature",
  ]

  subject {
    organization = local.org
    common_name  = local.cn
  }
}

resource "local_file" "ca" {
  filename        = "${path.root}/ca.crt"
  content         = tls_self_signed_cert.ca.cert_pem
  file_permission = "0644"
}
