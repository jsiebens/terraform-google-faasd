# faasd for Google Cloud Platform

This repo contains a Terraform Module for how to deploy a [faasd](https://github.com/openfaas/faasd) instance on the
[Google Cloud Platform](https://cloud.google.com/) using [Terraform](https://www.terraform.io/).

__faasd__, a lightweight & portable faas engine, is [OpenFaaS](https://github.com/openfaas/) reimagined, but without the cost and complexity of Kubernetes. It runs on a single host with very modest requirements, making it fast and easy to manage. Under the hood it uses [containerd](https://containerd.io/) and [Container Networking Interface (CNI)](https://github.com/containernetworking/cni) along with the same core OpenFaaS components from the main project.

## What's a Terraform Module?

A Terraform Module refers to a self-contained packages of Terraform configurations that are managed as a group. This repo
is a Terraform Module and contains many "submodules" which can be composed together to create useful infrastructure patterns.

## How do you use this module?

This repository defines a [Terraform module](https://www.terraform.io/docs/modules/usage.html), which you can use in your
code by adding a `module` configuration and setting its `source` parameter to URL of this repository:

```hcl
provider "google" {
  
}

module "faasd" {
  source = "github.com/jsiebens/terraform-google-faasd"

  name    = "faasd"
  project = var.project
  region  = var.region
  zone    = var.zone
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| google | >= 3.3 |
| random | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| google | >= 3.3 |
| random | >= 3.1.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_address.faasd](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_firewall.faasd_gateway](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.faasd_ssh](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_instance.faasd](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_project_iam_member.faasd](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.faasd](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [random_password.faasd](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| basic\_auth\_password | The basic auth password, if left empty, a random password is generated. | `string` | `null` | no |
| basic\_auth\_user | The basic auth user name. | `string` | `"admin"` | no |
| domain | A public domain for the faasd instance. This will the use of Caddy and a Let's Encrypt certificate | `string` | `""` | no |
| email | Email used to order a certificate from Let's Encrypt | `string` | `""` | no |
| machine\_type | The machine type of the Compute Instance to use for the faasd instance (e.g. e2-micro). | `string` | `"e2-medium"` | no |
| name | The name of the faasd instance. | `string` | n/a | yes |
| network | The name of the VPC Network where all resources should be created. | `string` | `"default"` | no |
| project | The id of the GCP Project where all resources will be launched. | `string` | `null` | no |
| region | The region in which all GCP resources will be launched. | `string` | `null` | no |
| subnetwork | The name of the VPC Subnetwork where all resources should be created. Defaults to the default subnetwork for the network and region. | `string` | `null` | no |
| tags | A list of the tags to be applied to the Compute Instance. | `list(string)` | <pre>[<br>  "faasd"<br>]</pre> | no |
| zone | The zone in which all GCP resources will be launched. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| basic\_auth\_password | The basic auth password. |
| basic\_auth\_user | The basic auth user name. |
| gateway\_url | The url of the faasd gateway |
| ipv4\_address | The public IP address of the faasd instance |
<!-- END_TF_DOCS -->

## See Also

- [faasd on Google Cloud Platform](https://github.com/jsiebens/terraform-google-faasd)
- [faasd on DigitalOcean](https://github.com/jsiebens/terraform-digitalocean-faasd)
- [faasd on Equinix Metal](https://github.com/jsiebens/terraform-equinix-faasd)