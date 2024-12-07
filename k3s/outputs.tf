output "endpoint" {
  description = "The endpoint of the k8s kube-apiserver"
  value       = local.endpoint
}

output "config" {
  description = "The kubeconfig to use when querying the kube-apiserver"
  value = {
    username               = local.config.users[0].name
    cluster_ca_certificate = base64decode(local.config.clusters[0].cluster.certificate-authority-data)
    client_certificate     = base64decode(local.config.users[0].user.client-certificate-data)
    client_key             = base64decode(local.config.users[0].user.client-key-data)
  }
}
