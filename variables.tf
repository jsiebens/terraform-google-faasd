variable project {
  description = "The id of the GCP Project where all resources will be launched."
  type        = string
}

variable region {
  description = "The region in which all GCP resources will be launched."
  type        = string
}

variable zone {
  description = "The zone in which all GCP resources will be launched."
  type        = string
}

variable network {
  description = "The name of the VPC Network where all resources should be created."
  type        = string
  default     = "default"
}

variable subnetwork {
  description = "The name of the VPC Subnetwork where all resources should be created. Defaults to the default subnetwork for the network and region."
  type        = string
  default     = null
}

variable machine_type {
  description = "The machine type of the Compute Instance to use for the faasd instance (e.g. e2-micro)."
  type        = string
  default     = "e2-micro"
}

variable ssh_allowed {
  description = "Allow SSH connections to the faasd instance"
  type        = bool
  default     = true
}

variable name {
  description = "The name of the faasd instance. All resources will be namespaced by this value. If left empty, a random name will be used (e.g. faasd-xrjc30)"
  type        = string
  default     = null
}
