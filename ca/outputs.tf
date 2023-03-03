output "ca" {
  description = "The main CA generated via the `hashicorp/tls` provider."
  value       = tls_self_signed_cert.ca
}
