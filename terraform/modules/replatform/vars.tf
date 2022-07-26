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
variable "subnetwork" {
  type     = string
  default = "default"
}


variable "region" {
  type     = string
  nullable = false
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
  default = "replatform"
}

locals {
  identity_namespace = "${var.project_id}.svc.id.goog"
  membership_id = "replatform-clusters"
  registry= "${var.region}-docker.pkg.dev/${var.project_id}/${var.project_id}"
  basename = "${var.dns_prefix}.${data.google_dns_managed_zone.dns_zone.dns_name}"
}

variable "sync_branch" {
  type = string
  nullable = true
  default = "master"
}

variable "kanboard_sa" {
  type = string
  default = "kanboard"
}

variable "template_git" {
  type = string
  default = "https://github.com/thekoma/samesoup-configsync"
}

variable "template_path" {
  type = string
  default = "./"
}

variable "ansible_config_path" {
  type = string
  default = "mainrepo"
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
