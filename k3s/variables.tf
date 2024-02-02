variable "user" {
  description = "The user to use in the SSH connection for both the tunnel and the config retrieval"
  type        = string
  default     = "root"
}

variable "address" {
  description = "The address of the server"
  type        = string
}

variable "port" {
  description = "The SSH port of the server"
  type        = number
}
