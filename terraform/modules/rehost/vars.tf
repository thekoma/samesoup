variable "module_depends_on" {
  # the value doesn't matter; we're just using this variable
  # to propagate dependencies.
  type    = any
  default = []
}

variable "project_id" {
  type     = string
  nullable = false
}

variable "service_account_id" {
  type      = string
  nullable  = true
  default   = "rehost"
}

variable "scopes" {
  type    = list(string)
  default = [
    "compute-ro",
    "storage-rw",
    "logging-write",
    "monitoring-write",
    "service-control",
    "service-management",
    "pubsub",
    "trace",
    "cloud-platform"
    ]
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "vm_name" {
  type    = string
  default = "rehost"
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "image_project" {
  type    = string
  default = "ubuntu-os-cloud"
}


variable "image_family" {
  type    = string
  default = "ubuntu-2204-lts"
}

locals {
  image_flavor = "${var.image_project}/${var.image_family}"
}
# Boot disk size in GB
variable "boot_disk_size" {
  type    = string
  default = "100"
}

variable "network" {
  type     = string
  nullable = false
}

variable "subnetwork" {
  type     = string
  nullable = false
}

variable "tags" {
  type     = list(string)
  default = [
    "ssh",
    "http",
    "https"
  ]
}

variable "php_config_secret_id" {
  type     = string
  nullable = false
}


variable "gcs_repo_url" {
  type     = string
  nullable = false
}

variable "gcs_repo_url_secret_id" {
  type     = string
  nullable = false
}

variable "gcs_repo_name" {
  type     = string
  nullable = false
}

variable "gcs_repo_name_secret_id" {
  type     = string
  nullable = false
}

variable "dns_zone" {
  type     = string
  nullable = false
}

variable "dns_project_id" {
  type     = string
  nullable = false
}

variable "dns_prefix" {
  type     = string
  nullable = false
}