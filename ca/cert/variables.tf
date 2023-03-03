variable "from" {
  description = "A reference to an already initialized `ca` module to forge the certificate from."
}

variable "bits" {
  description = "The number of bits to generate for the public/private key."
  default     = 4096
  type        = number
}

variable "validity" {
  description = "The validity of the requested certificate in hours."
  default     = 1 * 8760 # 3 year
  type        = number
}

variable "cn" {
  description = "The common name (cn) of the requested certificate."
  type        = string
}

variable "addresses" {
  description = "The IP addresses valid for the requested certificate."
  type        = list(string)
  default     = []
}

variable "domains" {
  description = "The DNS domains valid for the requested certificate."
  type        = list(string)
  default     = []
}
