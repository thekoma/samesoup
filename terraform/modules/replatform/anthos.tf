resource "google_gke_hub_membership" "replatform" {
  depends_on = [ module.enabled_google_apis ]
  membership_id = local.membership_id
  project       = var.project_id
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${module.gke.cluster_id}"
    }
  }
  provider = google-beta
}

resource "google_gke_hub_feature" "feature-configmanagement" {
  depends_on = [ module.enabled_google_apis ]
  project = var.project_id
  name = "configmanagement"
  location = "global"
  provider = google-beta
}

resource "google_gke_hub_feature_membership" "replatform_cluster" {
  depends_on = [ module.enabled_google_apis ]
  project     = var.project_id
  provider   = google-beta
  location   = "global"
  feature    = "configmanagement"
  membership = google_gke_hub_membership.replatform.membership_id
  configmanagement {
    #version = "1.8.0"
    config_sync {
      source_format = "hierarchy"
      git {
        sync_repo   = google_sourcerepo_repository.anthos_repo.url
        sync_branch = var.sync_branch
        policy_dir  = var.ansible_config_path
        secret_type = "gcpserviceaccount"
        gcp_service_account_email = google_service_account.anthos.email
      }
    }
    policy_controller {
      enabled                    = true
      template_library_installed = true
      referential_rules_enabled  = true
    }
  }
}