module "gke" {
  version                     = "~> 21.0"
  depends_on                  = [module.enabled_google_apis]
  source                      = "terraform-google-modules/kubernetes-engine/google"
  project_id                  = module.project-factory.project_id
  name                        = "${var.gke_cluster_name}-${local.name_suffix}"
  region                      = var.region
  release_channel             = "STABLE"
  enable_shielded_nodes       = true
  remove_default_node_pool    = false
  network                     = var.network_name
  subnetwork                  = var.subnetwork
  ip_range_pods               = var.ip_range_pods_name
  ip_range_services           = var.ip_range_services_name
  identity_namespace          = "${module.project-factory.project_id}.svc.id.goog"
}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

data "google_client_config" "default" {}

resource "google_artifact_registry_repository_iam_member" "registry-access" {
  project       = module.project-factory.project_id
  depends_on    = [google_artifact_registry_repository.demo-repo]
  provider = google-beta
  location = google_artifact_registry_repository.demo-repo.location
  repository = google_artifact_registry_repository.demo-repo.name
  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${module.gke.service_account}"
}