output "ipv4_address" {
  description = "The public IP address of the faasd instance"
  value       = google_compute_address.faasd.address
}

output "gateway_url" {
  description = "The url of the faasd gateway"
  value       = var.domain == null || var.domain == "" ? format("http:/%s:8080", google_compute_address.faasd.address) : format("https://%s", var.domain)
}

output "basic_auth_user" {
  description = "The basic auth user name."
  value       = local.basic_auth_user
}

output "basic_auth_password" {
  description = "The basic auth password."
  value       = local.basic_auth_password
  sensitive   = true
}
