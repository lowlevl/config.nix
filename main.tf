# Provision the k3s cluster with basic functionalities and get credentials.
module "k3s" {
  source = "./k3s"

  address = "s.unw.re"
  port    = 223
}

provider "kubernetes" {
  host = module.k3s.endpoint

  username               = module.k3s.config.username
  cluster_ca_certificate = module.k3s.config.cluster_ca_certificate
  client_certificate     = module.k3s.config.client_certificate
  client_key             = module.k3s.config.client_key
}

provider "helm" {
  kubernetes {
    host = module.k3s.endpoint

    username               = module.k3s.config.username
    cluster_ca_certificate = module.k3s.config.cluster_ca_certificate
    client_certificate     = module.k3s.config.client_certificate
    client_key             = module.k3s.config.client_key
  }
}

# The cluster's internal communication CA.
module "ca" {
  source = "./ca"

  org = "k3s.zion.internal"
  cn  = "R0"
}

# A CalDAV/CardDAV server.
module "xandikos" {
  source = "./services/xandikos"
  tag    = "v0.2.11"

  hostname = "cal.unw.re"
  username = "user"
}
