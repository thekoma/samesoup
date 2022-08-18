

module "gke" {
  version                     = "~> 22.1"
  source                      = "terraform-google-modules/kubernetes-engine/google"
  project_id                  = var.project_id
  name                        = var.gke_cluster_name
  region                      = var.region
  release_channel             = "REGULAR"
  enable_shielded_nodes       = true
  remove_default_node_pool    = false
  network                     = var.network
  subnetwork                  = google_compute_subnetwork.gke.name
  ip_range_pods               = var.ip_range_pods_name
  ip_range_services           = var.ip_range_services_name
  identity_namespace          = local.identity_namespace
  cluster_resource_labels     = { "mesh_id" : "proj-${data.google_project.project.number}" }
}