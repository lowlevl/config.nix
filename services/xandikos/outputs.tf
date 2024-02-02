output "username" {
  description = "The username of the Xandikos instance."
  value       = var.username
}

output "password" {
  description = "The username of the Xandikos instance."
  sensitive   = true
  value       = random_password.password.result
}
