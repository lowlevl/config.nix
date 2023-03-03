resource "random_string" "access_key_id" {
  length = 32

  special = false
  lower   = false
}

resource "random_password" "secret_access_key" {
  keepers = {
    id = random_string.access_key_id.result
  }

  length           = 48
  lower            = false
  min_special      = 1
  override_special = "/"
}
