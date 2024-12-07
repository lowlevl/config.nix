variable "passphrase" {
  description = "The state's encryption passphrase"
}

terraform {
  encryption {
    key_provider "pbkdf2" "mykey" {
      passphrase = var.passphrase
    }

    method "aes_gcm" "new_method" {
      keys = key_provider.pbkdf2.mykey
    }

    state {
      method = method.aes_gcm.new_method
      # enforced = true
    }
  }
}
