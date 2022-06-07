# The external load-balancer configuration
loadbalancer = {
  ip = "10.0.9.1"

  services = {
    # MinIO instance
    minio = {
      scheme   = "https"
      hostname = "d3r.internal"
      port     = 30001
    }

    # Outline instance
    outline = {
      scheme   = "http"
      hostname = "d3r.internal"
      port     = 30002
    }
  }
}
