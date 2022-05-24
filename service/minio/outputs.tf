output "endpoint" {
  value = "${kubernetes_service_v1.minio.status.0.load_balancer.0.ingress.0.ip}:${kubernetes_service_v1.minio.spec.0.port.0.port}"
}

output "access_key_id" {
  value = kubernetes_secret_v1.access_key_id.data.value
}

output "secret_access_key" {
  value = kubernetes_secret_v1.secret_access_key.data.value
}
