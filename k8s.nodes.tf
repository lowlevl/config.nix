locals {
  # Definition of the current k8s nodes
  nodes = {
    "d3r.internal" = {
      ip        = "10.0.9.1"
      hostnames = ["d3r.internal"]
    }
  }
}
