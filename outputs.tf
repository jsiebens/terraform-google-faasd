output "instance_ip" {
  value = google_compute_instance.faasd.network_interface.0.access_config.0.nat_ip
}

output "gateway_url" {
  value = format("http:/%s:8080", google_compute_instance.faasd.network_interface.0.access_config.0.nat_ip)
}

output "password" {
  value = random_password.admin.result
}

output "login_cmd" {
  value = format("faas-cli login -g http:/%s:8080 -p %s", google_compute_instance.faasd.network_interface.0.access_config.0.nat_ip, random_password.admin.result)
}
