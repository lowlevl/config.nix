data "remote_file" "kubeconfig" {
  conn {
    agent = true

    user = var.user
    host = var.address
    port = var.port
  }

  # Load the kubeconfig file from the server
  path = "/etc/rancher/k3s/k3s.yaml"
}
