variable "algorithm" {
  description = "The algorithm to use for the public/private key."
  default     = "RSA"
  type        = string
}

variable "bits" {
  description = "The number of bits to generate for the public/private key."
  default     = 4096
  type        = number
}

variable "validity" {
  description = "The validity of the generated CA in hours."
  default     = 3 * 8760 # 3 year
  type        = number
}

variable "org" {
  description = "The organization (org) of the CA to generate."
  type        = string
}

variable "cn" {
  description = "The common name (cn) of the CA to generate."
  type        = string
}

variable "path" {
  description = "The path where the CA will be output when generated."
  type        = string
  default     = null
}
