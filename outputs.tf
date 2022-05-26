resource "local_file" "ca" {
  filename        = "${path.root}/ca.crt"
  content         = module.secrets.ca
  file_permission = "0444"
}

output "minio" {
  sensitive = true

  value = {
    ACCESS_KEY_ID     = module.secrets.minio.ACCESS_KEY_ID
    SECRET_ACCESS_KEY = module.secrets.minio.SECRET_ACCESS_KEY
  }
}
