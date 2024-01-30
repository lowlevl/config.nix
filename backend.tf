terraform {
  backend "s3" {
    bucket = "otf"
    key    = "infra.state"

    use_path_style            = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_credentials_validation = true
  }
}

