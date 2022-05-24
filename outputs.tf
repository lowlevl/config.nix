output "minio_endpoint" {
  value = module.minio.endpoint
}

output "minio_access_key_id" {
  value     = module.minio.access_key_id
  sensitive = true
}

output "minio_secret_access_key" {
  value     = module.minio.secret_access_key
  sensitive = true
}
