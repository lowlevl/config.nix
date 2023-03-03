output "crt" {
  description = "The generated certificate in PEM format."
  value       = tls_locally_signed_cert.cert.cert_pem
}

output "key" {
  description = "The generated private key for the certificate in PEM format."
  value       = tls_private_key.private_key.private_key_pem
  sensitive   = true
}
