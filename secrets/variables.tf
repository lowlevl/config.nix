variable "minio" {
  description = "Parameters required to generate the secrets for the `MinIO` app."
  type = object({
    ip        = list(string)
    hostnames = list(string)
  })
  nullable = false
}
