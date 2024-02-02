output "credentials" {
  description = "The various automagically generated credentials for the services."
  sensitive   = true
  value = {
    xandikos = module.xandikos
  }
}
