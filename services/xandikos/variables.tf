variable "tag" {
  description = "The Xandikos docker image tag."
}

variable "hostname" {
  description = "The Xandikos service hostname."
  type        = string
}

variable "username" {
  description = "The Xandikos username to be used with HTTP Basic Auth."
  type        = string
}
