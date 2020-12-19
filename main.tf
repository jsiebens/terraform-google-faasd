terraform {
  required_version = ">= 0.13"

  required_providers {
    google = ">= 3.3"
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

resource "random_string" "id" {
  length  = 6
  upper   = false
  special = false
}

locals {
  faasd_name = var.name != null && var.name != "" ? var.name : format("faasd-%s", random_string.id.result)
  account_id = var.name != null && var.name != "" ? format("%s-%s", var.name, random_string.id.result) : format("faasd-%s", random_string.id.result)
}

resource "google_compute_address" "faasd" {
  name = local.faasd_name
}

resource "google_compute_firewall" "faasd-firewall-gateway" {
  name    = format("%s-allow-gateway", local.faasd_name)
  network = var.network
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = [local.faasd_name]
}

resource "google_compute_firewall" "faasd-firewall-ssh" {
  count   = var.ssh_allowed ? 1 : 0
  name    = format("%s-allow-ssh", local.faasd_name)
  network = var.network
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = [local.faasd_name]
}

resource "random_string" "sa_id" {
  length  = 5
  upper   = false
  special = false
}

resource "google_service_account" "faasd" {
  account_id = local.account_id
}

resource "google_project_iam_member" "faasd-log-writer" {
  role   = "roles/logging.logWriter"
  member = "serviceAccount:${google_service_account.faasd.email}"
}

resource "random_password" "admin" {
  length  = 16
  special = false
}

data "template_file" "faasd" {
  template = file("${path.module}/templates/startup.sh")
  vars = {
    gw_password = random_password.admin.result
  }
}

resource "google_compute_instance" "faasd" {
  name         = local.faasd_name
  zone         = var.zone
  machine_type = var.machine_type

  metadata_startup_script = data.template_file.faasd.rendered

  metadata = {
    block-project-ssh-keys = "TRUE"
    enable-oslogin         = "TRUE"
  }

  boot_disk {
    initialize_params {
      size  = 50
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {
      nat_ip = google_compute_address.faasd.address
    }
  }

  tags = [local.faasd_name]

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
