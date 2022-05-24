variable "minio_ssl_cert_path" {
  description = "The local path to the SSL certificate file for MinIO."
  type        = string
  nullable    = false
}

variable "minio_ssl_key_path" {
  description = "The local path to the SSL private key file for MinIO."
  type        = string
  nullable    = false
}
