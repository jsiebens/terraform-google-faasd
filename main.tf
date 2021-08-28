locals {
  generate_password   = var.basic_auth_password == null || var.basic_auth_password == ""
  basic_auth_user     = var.basic_auth_user
  basic_auth_password = local.generate_password ? random_password.faasd[0].result : var.basic_auth_password

  user_data_vars = {
    basic_auth_user     = local.basic_auth_user
    basic_auth_password = local.basic_auth_password
    domain              = var.domain
    email               = var.email
  }
}

resource "random_password" "faasd" {
  count   = local.generate_password ? 1 : 0
  length  = 16
  special = false
}

resource "google_compute_address" "faasd" {
  project = var.project
  region  = var.region
  name    = var.name
}

resource "google_service_account" "faasd" {
  project    = var.project
  account_id = format("sa-%s", var.name)
}

resource "google_project_iam_member" "faasd" {
  project  = var.project
  for_each = toset(["roles/logging.logWriter", "roles/monitoring.metricWriter"])
  role     = each.value
  member   = format("serviceAccount:%s", google_service_account.faasd.email)
}

resource "google_compute_instance" "faasd" {
  project      = var.project
  name         = var.name
  zone         = var.zone
  machine_type = var.machine_type

  metadata_startup_script = templatefile("${path.module}/templates/startup.sh", local.user_data_vars)

  metadata = {
    enable-oslogin = "TRUE"
  }

  boot_disk {
    initialize_params {
      size  = 50
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {
      nat_ip = google_compute_address.faasd.address
    }
  }

  tags = var.tags

  shielded_instance_config {
    enable_secure_boot = true
  }

  service_account {
    email = google_service_account.faasd.email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

}

resource "google_compute_firewall" "faasd_gateway" {
  project = var.project
  name    = format("%s-allow-gateway", var.name)
  network = var.network
  allow {
    protocol = "tcp"
    ports    = var.domain == "" ? ["8080"] : ["80", "443"]
  }
  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = [google_service_account.faasd.email]
}

resource "google_compute_firewall" "faasd_ssh" {
  project = var.project
  name    = format("%s-allow-ssh", var.name)
  network = var.network
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges           = ["35.235.240.0/20"]
  target_service_accounts = [google_service_account.faasd.email]
}
