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
  cluster_resource_labels = { "mesh_id" : "proj-${data.google_project.project.number}" }
}

output "pool_id" {
  value = module.gke.identity_namespace
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
      source_format = "unstructured"
      git {
        sync_repo   = google_sourcerepo_repository.anthos_repo.url
        sync_branch = var.sync_branch
        policy_dir  = var.policy_dir
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

resource "google_service_account_iam_binding" "enable_anthos_to_sa" {
  service_account_id = google_service_account.repo_admin.id
  role               = "roles/iam.workloadIdentityUser"
  members = [ "serviceAccount:${var.project_id}.svc.id.goog[config-management-system/root-reconciler]" ]
}

resource "google_service_account" "repo_admin" {
  project       = var.project_id
  account_id    = "anthos-repo-admin"
  display_name  = "Service Account for the webapp"
}

resource "google_project_iam_member" "repo_admin_role" {
  project = var.project_id
  role    = "roles/source.admin"
  member  = "serviceAccount:${google_service_account.repo_admin.email}"
}

data "google_client_config" "default" {}
