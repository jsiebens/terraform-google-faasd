terraform {
  required_version = ">= 1.4.1"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.59.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3"
    }
  }
}