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
  source              = "./modules/rehost"
  network             = module.gcp-network.network_id
  primary-zone        = var.primary-zone
  subnetwork          = module.gcp-network.subnets_ids[0]
  subnet_ip           = var.subnet_ip
  project_id          = module.project-factory.project_id
  tags                = ["ssh","http","https"]
  service_account_id  = google_service_account.rehost.id
}
module "replatform" {
  source                  = "./modules/replatform"
  network_name            = module.gcp-network.network_name
  primary-zone            = var.primary-zone
  subnetwork_name         = module.gcp-network.subnets_names[0]
  subnet_ip               = var.subnet_ip
  project_id              = module.project-factory.project_id
  ip_range_pods_name      = var.ip_range_pods_name
  ip_range_services_name  = var.ip_range_services_name
  gke_cluster_name        = "replatform"
  # depends_on        = [module.enabled_google_apis]
}