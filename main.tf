module "k8s" {
  source = "./k8s"

  address = "zion.internal"
  port    = "223"
}

module "ca" {
  source = "./ca"

  org = "k3s.zion.internal"
  cn  = "R0"
}
