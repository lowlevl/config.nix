variable "port" {
  description = "The port on which the Outline instance will be bound."
  type        = number
  nullable    = false
}

variable "volume" {
  description = "The volume on which the Outline instance will be bound."
  nullable    = false
}

variable "s3" {
  description = "The s3 parameters for the Outline instance."
  type = object({
    endpoint = string
    bucket   = string
    max_size = number
  })
  nullable = false
}

variable "secrets" {
  description = "The secret parameters for the Outline instance."
  type = object({
    URL = string

    SECRET_KEY   = string
    UTILS_SECRET = string

    SMTP_HOST        = string
    SMTP_PORT        = number
    SMTP_SECURE      = string
    SMTP_USERNAME    = string
    SMTP_PASSWORD    = string
    SMTP_FROM_EMAIL  = string
    SMTP_REPLY_EMAIL = string
  })
  nullable = false
}
