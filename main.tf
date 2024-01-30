module "ca" {
  source = "./ca"

  org = "k3s.zion.internal"
  cn  = "R0"
}

module "k8s" {
  source = "./k8s"

  address = "s.unw.re"
  port    = 223
}
