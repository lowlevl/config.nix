output "access_key_id" {
  value = kubernetes_secret_v1.credentials.data.ACCESS_KEY_ID
}

output "secret_access_key" {
  value = kubernetes_secret_v1.credentials.data.SECRET_ACCESS_KEY
}
