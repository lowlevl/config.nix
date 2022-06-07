output "ca" {
  description = "The main CA generated via the `hashicorp/tls` provider."
  value = {
    pem  = tls_self_signed_cert.ca.cert_pem
    path = local_file.ca.filename
  }
}

output "minio" {
  description = "The secrets for the `MinIO` app."
  sensitive   = true

  value = {
    ACCESS_KEY_ID     = random_string.minio_access_key_id.result
    SECRET_ACCESS_KEY = random_password.minio_secret_access_key.result

    tls = {
      crt = tls_locally_signed_cert.minio_ssl.cert_pem
      key = tls_private_key.minio_ssl.private_key_pem
    }
  }
}

output "outline" {
  description = "The secrets for the `Outline` app."
  sensitive   = true

  value = {
    UTILS_SECRET = random_password.outline_utils_secret.result
  }
}
