terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}
data "google_project" "project" {
  project_id = var.project_id
}

data "google_client_openid_userinfo" "self" {
}
data "google_compute_network" "main_network" {
  name = var.network_name
  project = var.project_id
}

data "google_client_config" "default" {}
