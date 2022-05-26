variable "port" {
  description = "The port on which the Outline instance will be bound."
  type        = number
  nullable    = false
}

variable "volume" {
  description = "The volume on which the App will store data."
  nullable    = false
}
