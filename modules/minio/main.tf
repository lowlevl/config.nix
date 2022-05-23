terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"
    }
  }
}

resource "docker_image" "minio" {
  name = "minio/minio:${var.tag}"
}

resource "docker_container" "minio" {
  image = docker_image.minio[var.tag]
  name  = "minio.minio"

  command = ["server", "/data", "--certs-dir", "/certs"]
  memory  = 256 /* MB */
  user    = var.user

  restart = "unless-stopped"

  env = [
    "MINIO_BROWSER=off",
    "MINIO_ROOT_USER=${var.access-key-id}",
    "MINIO_ROOT_PASSWORD=${var.secret-access-key}"
  ]

  mounts {
    type   = "bind"
    source = var.data-mount
    target = "/data"
  }

  mounts {
    type   = "bind"
    source = var.certs-mount
    target = "/certs"
  }

  ports {
    internal = 9000
    external = var.port
  }

  healthcheck {
    test = ["CMD", "curl", "-f", "http://localhost:9000/minio/health/live"]

    interval = "3s"
    timeout  = "1s"
    retries  = 3
  }
}
