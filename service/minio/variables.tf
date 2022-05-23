variable "ssl_cert_path" {
  description = "The local path to the SSL certificate file."
  type        = string
  nullable    = false
}

variable "ssl_key_path" {
  description = "The local path to the SSL private key file."
  type        = string
  nullable    = false
}
