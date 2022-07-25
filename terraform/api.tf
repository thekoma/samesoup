module "enabled_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 13.0.0"

  project_id                  = module.project-factory.project_id
  disable_services_on_destroy = false

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "gkehub.googleapis.com",
    "anthosconfigmanagement.googleapis.com",
    "anthos.googleapis.com",
    "meshconfig.googleapis.com",
    "servicemanagement.googleapis.com",
    "meshca.googleapis.com",
    "stackdriver.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "meshtelemetry.googleapis.com",
    "cloudtrace.googleapis.com",
    "logging.googleapis.com",
    "containerregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    "gkehub.googleapis.com",
    "appdevelopmentexperience.googleapis.com"
  ]
}