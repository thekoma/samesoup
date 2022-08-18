# This needs to be moved in each module and reduced to bits
module "enabled_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 13.0.0"

  project_id                  = var.project_id
  disable_services_on_destroy = false

  activate_apis = [
    "secretmanager.googleapis.com"
  ]
}