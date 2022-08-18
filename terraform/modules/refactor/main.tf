# cloudrun

resource "google_cloud_run_service" "refactor" {
  name      = "refactor"
  location  = var.region
  project   = var.project_id

  lifecycle {
    ignore_changes = [
      template[0].metadata[0].annotations["client.knative.dev/user-image"],
      template[0].metadata[0].annotations["run.googleapis.com/client-name"],
      template[0].metadata[0].annotations["run.googleapis.com/client-version"],
      template[0].metadata[0].annotations["run.googleapis.com/sandbox"],
      metadata[0].annotations["serving.knative.dev/creator"],
      metadata[0].annotations["serving.knative.dev/lastModifier"],
      metadata[0].annotations["run.googleapis.com/ingress-status"],
      metadata[0].annotations["run.googleapis.com/launch-stage"],
      metadata[0].labels["cloud.googleapis.com/location"],
    ]
  }
  template {
    spec {
      service_account_name = google_service_account.refactor_sa.email
      containers {
        image = local.container_image
        command = [ "/usr/local/bin/entrypoint_cloudrun.sh" ]
        volume_mounts {
          name       = "config_php"
          mount_path = "/secrets"
        }
        ports {
          container_port = 80
        }
      }

      volumes {
        name = "config_php"
        secret {
          secret_name  = var.php_config_secret_id
          items {
            key  = "latest"
            path = "config.php"
          }
        }
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "1000"
        "autoscaling.knative.dev/minScale"      = "1"
        "run.googleapis.com/vpc-access-egress" = "private-ranges-only"
        "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.connector.id
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}



resource "google_compute_region_network_endpoint_group" "refactor_neg" {
  provider              = google-beta
  project               = var.project_id
  name                  = "refactor-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = google_cloud_run_service.refactor.name
  }
}

module "lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  version = "~> 6.3"
  name    = "refactor-lb"
  project = var.project_id
  ssl                             = true
  managed_ssl_certificate_domains = [
    "refactor.${local.basename}"
  ]
  https_redirect                  = true

  backends = {
    default = {
      description = null
      groups = [
        {
          group = google_compute_region_network_endpoint_group.refactor_neg.id
        }
      ]
      enable_cdn              = false
      security_policy         = null
      custom_request_headers  = null
      custom_response_headers = null

      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
      log_config = {
        enable      = false
        sample_rate = null
      }
    }
  }
}


