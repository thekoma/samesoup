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
  project_id          = module.project-factory.project_id
  network             = google_compute_network.main-network.id
  subnetwork          = data.google_compute_subnetwork.sub_nat_net.id
  primary-zone        = var.primary-zone
  tags                = ["ssh","http","https"]
  service_account_id  = google_service_account.rehost.id
}
module "replatform" {
  source                  = "./modules/replatform"
  network_name            = var.network_name
  primary-zone            = var.primary-zone
  project_id              = module.project-factory.project_id
  ip_range_pods_name      = var.ip_range_pods_name
  ip_range_services_name  = var.ip_range_services_name
  gke_cluster_name        = "replatform"
  # depends_on        = [module.enabled_google_apis]
}



module "dns" {
  source              = "./modules/dns"
  project_id          = var.dns_project_id # The name of the project that manages the zone
  prefix_name         = var.project_name   # This will be used to create the zone prefix
  dns_zone            = var.dns_zone
  rehost_endpoint     = module.rehost.instance_ip_addr
  # replatform_endpoint =
}
