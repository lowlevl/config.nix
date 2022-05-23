#! The server on which everything will be deployed
ssh = {
  user = "root"
  host = "d3r.internal"
  port = "223"
}

minio-dir           = "/srv/minio"
minio-user          = 10001
minio-ssl-cert-path = "./secrets/public.crt"
minio-ssl-key-path  = "./secrets/private.key"
