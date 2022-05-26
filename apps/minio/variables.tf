variable "nodes" {
  description = "The nodes hostnames on which the MinIO pods will be scheduled."
  type        = list(string)
  nullable    = false
}

variable "port" {
  description = "The port on which the MinIO server will be bound."
  type        = number
  nullable    = false
}

variable "volume" {
  description = "The volume on which the MinIO server will be bound."
  nullable    = false
}

variable "ssl" {
  description = "The SSL certificate and key for the MinIO server."
  type = object({
    crt = string
    key = string
  })
  nullable = false
}

variable "credentials" {
  description = "The root credentials for the MinIO server."
  type = object({
    ACCESS_KEY_ID     = string
    SECRET_ACCESS_KEY = string
  })
  nullable = false
}
