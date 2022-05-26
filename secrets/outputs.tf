output "ca" {
  description = "The main CA generated via the `hashicorp/tls` provider."
  value       = tls_self_signed_cert.ca.cert_pem
}

output "minio" {
  description = "The secrets for the `MinIO` app."
  sensitive   = true

  value = {
    ACCESS_KEY_ID     = random_uuid.minio_access_key_id.result
    SECRET_ACCESS_KEY = random_password.minio_secret_access_key.result

    ssl = {
      crt = tls_locally_signed_cert.minio_ssl.cert_pem
      key = tls_private_key.minio_ssl.private_key_pem
    }
  }
}
