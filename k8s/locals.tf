locals {
  kubeconfig = data.remote_file.kubeconfig.content

  endpoint = "https://${module.tunnel.host}:${module.tunnel.port}"
  config   = yamldecode(local.kubeconfig)
}
