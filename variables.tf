variable "node" {
  description = "The description of the node that is not managed by terraform."
  type = object({
    ip = string
    services = map(object({
      scheme   = string
      hostname = string
      port     = number
    }))
  })
  nullable = false
}
