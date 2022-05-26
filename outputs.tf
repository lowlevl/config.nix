output "minio" {
  sensitive = true

  value = {
    ACCESS_KEY_ID     = module.secrets.minio.ACCESS_KEY_ID
    SECRET_ACCESS_KEY = module.secrets.minio.SECRET_ACCESS_KEY
  }
}
