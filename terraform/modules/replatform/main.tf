terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

data "google_project" "project" {
  project_id = var.project_id
}
data "google_compute_network" "main-network" {
  name = var.network_name
  project = var.project_id
}

resource "google_compute_subnetwork" "gke" {
  project       = var.project_id
  name          = "replatform"
  ip_cidr_range = var.subnet_ip
  region        = var.region
  network       = data.google_compute_network.main-network.id
  secondary_ip_range {
    range_name    = var.ip_range_services_name
    ip_cidr_range = var.svcs_subnet_ip
  }

  secondary_ip_range {
    range_name    = var.ip_range_pods_name
    ip_cidr_range = var.pods_subnet_ip
  }
}

module "gke" {
  # version                     = "~> 22.0"
  source                      = "terraform-google-modules/kubernetes-engine/google"
  project_id                  = var.project_id
  name                        = var.gke_cluster_name
  region                      = var.region
  release_channel             = "STABLE"
  enable_shielded_nodes       = true
  remove_default_node_pool    = false
  network                     = var.network_name
  subnetwork                  = google_compute_subnetwork.gke.name
  ip_range_pods               = var.ip_range_pods_name
  ip_range_services           = var.ip_range_services_name
  identity_namespace          = "${var.project_id}.svc.id.goog"
}

resource "google_service_account" "metrics" {
  project       = var.project_id
  account_id    = "metrics-driver"
  display_name  = "Service Account for the metrics"
}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

provider "kubectl" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  alias = "replatform"
}

data "google_client_config" "default" {}

resource "kubernetes_namespace" "custom-metrics" {
  metadata {
    name = "custom-metrics"
  }
}

resource "kubernetes_service_account" "custom-metrics-stackdriver-adapter" {
  depends_on = [ kubernetes_namespace.custom-metrics ]
  metadata {
    name        = "custom-metrics-stackdriver-adapter"
    namespace   = "custom-metrics"
    annotations = {
      "iam.gke.io/gcp-service-account" = "metrics-driver@${var.project_id}.iam.gserviceaccount.com"
    }
  }
}

data "kubectl_filename_list" "custom-metrics-stackdriver-adapter-manifests" {
  pattern = "${path.module}/manifests/custom-metrics/*.yaml"
}

resource "kubectl_manifest" "custom-metrics-stackdriver-adapter" {
  depends_on = [ kubernetes_service_account.custom-metrics-stackdriver-adapter ]
  count = length(data.kubectl_filename_list.custom-metrics-stackdriver-adapter-manifests.matches)
  yaml_body = file(element(data.kubectl_filename_list.custom-metrics-stackdriver-adapter-manifests.matches, count.index))
}
