terraform {
  required_providers {
    remote = {
      source  = "tenstad/remote"
      version = "0.1.2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

provider "kubectl" {
  alias = "local"

  host = local.endpoint

  username               = local.config.users.0.name
  client_certificate     = base64decode(local.config.users.0.user["client-certificate-data"])
  client_key             = base64decode(local.config.users.0.user["client-key-data"])
  cluster_ca_certificate = base64decode(local.config.clusters.0.cluster["certificate-authority-data"])
  load_config_file       = false
}
