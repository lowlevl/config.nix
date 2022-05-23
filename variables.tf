variable "ssh" {
  description = "The host on which the containers will be deployed."
  type = object({
    user = string
    host = string
    port = number
  })
  nullable = false
}

variable "minio-dir" {
  description = "The directory where data will be stored on the remote server."
  type        = string
  nullable    = false
}

variable "minio-user" {
  description = "The unix user to be used on the remote server."
  type        = number
  nullable    = false
}

variable "minio-access-key-id" {
  description = "The root Access Key ID for MinIO."
  type        = string
  nullable    = false
}

variable "minio-secret-access-key" {
  description = "The root Secret Access Key for MinIO."
  type        = string
  nullable    = false
  sensitive   = true
}

variable "minio-ssl-cert-path" {
  description = "The local path to the SSL certificate file."
  type        = string
  nullable    = false
}

variable "minio-ssl-key-path" {
  description = "The local path to the SSL private key file."
  type        = string
  nullable    = false
}
