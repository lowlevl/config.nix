module "tunnel" {
  source  = "flaupretre/tunnel/ssh"
  version = "1.13.0"

  # Target the local kube-apiserver on port 6443
  target_host = "127.0.0.1"
  target_port = 6443

  # Use provided parameters to open the tunnel
  gateway_user = var.user
  gateway_host = var.address
  gateway_port = var.port
}
