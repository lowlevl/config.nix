variable "tag" {
  description = "The Docker tag of the MinIO server to use for deployment."
  default     = "latest"
  type        = string
  nullable    = false
}

variable "user" {
  description = "The user for the container on the target machine."
  type        = number
}

variable "data-mount" {
  description = "The /data mountpoint for the container on the target machine."
  type        = string
  nullable    = false
}

variable "certs-mount" {
  description = "The /certs mountpoint for the container on the target machine."
  type        = string
  nullable    = false
}

variable "port" {
  description = "The port on which the container will be exposed on the target machine."
  type        = number
  nullable    = false
}

variable "access-key-id" {
  description = "The root Access Key ID for this MinIO instance."
  type        = string
  nullable    = false
}

variable "secret-access-key" {
  description = "The root Secret Access Key for this MinIO instance."
  type        = string
  nullable    = false
  sensitive   = true
}
