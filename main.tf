module "ca" {
  source = "./ca"

  org = "k3s.d3r.internal"
  cn  = "R0"
}
