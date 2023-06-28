output "endpoint" {
  description = "The endpoint of the k8s kube-apiserver"
  value       = local.endpoint
}

output "config" {
  description = "The kubeconfig to use when querying the kube-apiserver"
  value       = local.config
}
