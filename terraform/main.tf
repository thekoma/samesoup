provider "google" {
  credentials = fileexists(var.gcp_creds) ? var.gcp_creds : null
  region      = var.region
}

provider "google-beta" {
  credentials = fileexists(var.gcp_creds) ? var.gcp_creds : null
  region      = var.region
}
module "project-factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 13.0.0"
  name                 = var.project_name
  folder_id            = var.folder_id
  random_project_id    = true
  org_id               = var.org_id
  billing_account      = var.billing_account
  activate_apis        = [
    "compute.googleapis.com"
  ]
  auto_create_network = true
}

module "rehost" {
  source = "./modules/rehost"
  network_name = var.network_name
  primary-zone = var.primary-zone
  subnetwork = var.subnetwork
}