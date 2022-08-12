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

module "gke" {
  version                     = "~> 22.1"
  source                      = "terraform-google-modules/kubernetes-engine/google"
  project_id                  = var.project_id
  name                        = var.gke_cluster_name
  region                      = var.region
  release_channel             = "REGULAR"
  enable_shielded_nodes       = true
  remove_default_node_pool    = false
  network                     = var.network_name
  subnetwork                  = google_compute_subnetwork.gke.name
  ip_range_pods               = var.ip_range_pods_name
  ip_range_services           = var.ip_range_services_name
  identity_namespace          = "${var.project_id}.svc.id.goog"
  cluster_resource_labels = { "mesh_id" : "proj-${data.google_project.project.number}" }
}

resource "google_gke_hub_membership" "soup" {
  membership_id = "soup-membership"
  project       = var.project_id
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${module.gke.cluster_id}"
    }
  }
  provider = google-beta
}
resource "google_gke_hub_feature" "feature" {
  project = var.project_id
  name = "configmanagement"
  location = "global"
  provider = google-beta
}

resource "google_gke_hub_feature_membership" "soup_cluster" {
  project     = var.project_id
  provider   = google-beta
  location   = "global"
  feature    = "configmanagement"
  membership = google_gke_hub_membership.soup.membership_id
  configmanagement {
    #version = "1.8.0"
    config_sync {
      source_format = "hierarchy"
      git {
        sync_repo   = google_sourcerepo_repository.anthos_repo.url
        sync_branch = var.sync_branch
        policy_dir  = var.template_path_mainrepo
        secret_type = "gcpserviceaccount"
        gcp_service_account_email = google_service_account.repo_admin.email
      }
    }
    policy_controller {
      enabled                    = true
      template_library_installed = true
      referential_rules_enabled  = true
    }
  }
}