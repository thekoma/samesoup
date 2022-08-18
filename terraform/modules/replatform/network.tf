data "google_compute_network" "main_network" {
  name = var.network
  project = var.project_id
}
resource "google_compute_subnetwork" "gke" {
  project       = var.project_id
  name          = "replatform"
  ip_cidr_range = var.subnet_ip
  region        = var.region
  network       = data.google_compute_network.main_network.id
  secondary_ip_range {
    range_name    = var.ip_range_services_name
    ip_cidr_range = var.svcs_subnet_ip
  }

  secondary_ip_range {
    range_name    = var.ip_range_pods_name
    ip_cidr_range = var.pods_subnet_ip
  }
}
resource "google_compute_global_address" "replatform" {
  project       = var.project_id
  name          = "replatform-gke"
  address_type  = "EXTERNAL"
}