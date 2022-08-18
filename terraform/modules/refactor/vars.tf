variable "module_depends_on" {
  # the value doesn't matter; we're just using this variable
  # to propagate dependencies.
  type    = any
  default = []
}

variable "php_config_secret_id" {
  type     = string
  nullable = false
}


variable "project_id" {
  type     = string
  nullable = false
}


variable "network" {
  type     = string
  nullable = false
}

variable "region" {
  type     = string
  nullable = false
}


variable "db_connection_name" {
  type     = string
  nullable = false
}

variable "image" {
  type     = string
  nullable = true
  default = "kanboard:latest"
}

variable "refactor_sa_name" {
  type     = string
  nullable = true
  default = "refactor"
}

locals {
  identity_namespace = "${var.project_id}.svc.id.goog"
  membership_id = "replatform-clusters"
  registry= "${var.region}-docker.pkg.dev/${var.project_id}/${var.project_id}"
  basename = "${var.dns_prefix}.${data.google_dns_managed_zone.dns_zone.dns_name}"
  container_image = "${local.registry}/${var.image}"
}

variable "connector_cidr" {
  type     = string
  description = "Network to connect to db from CloudRun"
  default = "10.8.0.0/28"
}
variable "connector_name" {
  type     = string
  default = "refactor"
}

variable "dns_project_id" {
  type = string
  nullable = false
}

variable "dns_zone" {
  type = string
  nullable = false
}

variable "dns_prefix" {
  type = string
  nullable = false
}
