variable "project_name" {
  type     = string
  nullable = false
}

variable "org_id" {
  type     = string
  nullable = false
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


variable "zones" {
  type    = list(string)
  default = [
    "us-central1-a",
    "us-central1-b",
    "us-central1-c"
  ]
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


variable "subnet_ip" {
  type     = string
  default = "10.0.0.0/17"
}

variable "pods_subnet_ip" {
  type     = string
  default = "192.168.0.0/18"
}

variable "svcs_subnet_ip" {
  type     = string
  default = "192.168.64.0/18"
}


variable "gke_cluster_name" {
  type     = string
  default = "cluster"
}

resource "random_string" "suffix" {
  length           = 5
  special          = false
  lower            = true
  upper            = false
}

locals {
  name_suffix = "${random_string.suffix.result}"
  cloudrun_revision_name = "cloud-run"
}


variable "gcp_creds" {
  type     = string
  default = "./credentials.json"
}