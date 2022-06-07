variable "loadbalancer" {
  description = "The description of the load balancer that is not managed by terraform."
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

variable "outline" {
  description = "The Outline parameters, mainly for SMTP."
  type = object({
    SECRET_KEY = string

    SMTP_HOST        = string
    SMTP_PORT        = number
    SMTP_USERNAME    = string
    SMTP_PASSWORD    = string
    SMTP_FROM_EMAIL  = string
    SMTP_REPLY_EMAIL = string
  })
  nullable = false
}
