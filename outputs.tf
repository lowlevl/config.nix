data "kubernetes_nodes" "nodes" {}

output "nodes" {
  description = "The cluster's informations."
  value       = { for node in data.kubernetes_nodes.nodes.nodes : node.metadata.0.name => node.status.0.node_info.0 }
}

output "credentials" {
  description = "The various automagically generated credentials for the services."
  sensitive   = true
  value = {
    xandikos = module.xandikos
  }
}
