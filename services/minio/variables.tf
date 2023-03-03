variable "node" {
  description = "The node definition on which the service will be deployed."
}

variable "service" {
  description = "The MinIO's service configuration."
}

variable "ca" {
  description = "The certificate authority used to forge a certificate for the app."
}
