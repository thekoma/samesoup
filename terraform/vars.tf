variable "project_name" {
  type     = string
  nullable = false
}

variable "org_id" {
  type     = string
  nullable = false
}

variable "dns_project_id" {
  type     = string
  nullable = false
}


variable "dns_zone" {
  type     = string
  nullable = true
  default = "demo"
}

variable "billing_account" {
  type     = string
  nullable = false
}

variable "folder_id" {
  type     = string
  nullable = true
}

variable "network_name" {
  type     = string
  default = "default"
}

variable "subnetwork" {
  type     = string
  default = "default"
}

variable "region" {
  type     = string
  default = "us-central1"
}

variable "location" {
  type     = string
  default = "US"
}

variable "primary-zone" {
  type    = string
  default = "us-central1-a"
}

variable "ip_range_pods_name" {
  type     = string
  default = "pods"
}

variable "ip_range_services_name" {
  type     = string
  default = "svcs"
}

resource "random_string" "suffix" {
  length           = 5
  special          = false
  lower            = true
  upper            = false
}

variable "gcp_creds" {
  type     = string
  default = "./credentials.json"
}

locals {
  postgres_db_name = "demoapp"
}

locals {
  postgres_user = "demoapp"
}


locals {
  dns_basename = "${var.project_name}.${data.google_dns_managed_zone.soup.dns_name}"
}

locals {
  rehost_mig_domain = "rehost-mig.${local.dns_basename}"
}


variable "template_git" {
  type = string
  default = "https://github.com/thekoma/samesoup-configsync"
}

variable "template_path" {
  type = string
  default = "."
}

variable "template_path_mainrepo" {
  type = string
  default = "mainrepo"
}
