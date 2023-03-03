# The node configuration
node = {
  ip       = "10.0.9.1"
  hostname = "d3r.internal"
}

# The services configuration
services = {
  # MinIO instance
  minio = {
    scheme = "https"
    port   = 30001
  }
}
