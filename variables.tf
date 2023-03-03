variable "node" {
  description = "The description of the node that is not managed by terraform."
  type = object({
    ip       = string
    hostname = string
  })
  nullable = false
}

variable "services" {
  description = "The description of the services an where they should be deployed."
  type = map(object({
    scheme = string
    port   = number
  }))
  nullable = false
}
