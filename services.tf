module "minio" {
  source = "./services/minio"

  service = var.services["minio"]
  node    = var.node
  ca      = module.ca
}
