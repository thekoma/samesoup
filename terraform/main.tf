
provider "google" {
  credentials = fileexists("${path.root}/${var.gcp_creds}") ? file("${path.root}/${var.gcp_creds}") : null
  region      = var.region
  project     = local.project_id
}

provider "google-beta" {
  credentials = fileexists("${path.root}/${var.gcp_creds}") ? file("${path.root}/${var.gcp_creds}") : null
  region      = var.region
  project     = local.project_id
}

module "project-factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 13.0.0"
  name                 = var.project_name
  folder_id            = var.folder_id
  project_id           = local.project_id
  org_id               = var.org_id
  billing_account      = var.billing_account
  activate_apis        = [
    "compute.googleapis.com",
    "secretmanager.googleapis.com",
    "dns.googleapis.com"
  ]
  auto_create_network = true
}



# Single instance
# module "rehost" {
#   source              = "./modules/rehost"
#   project_id          = module.project-factory.project_id
#   network             = google_compute_network.main_network.id
#   subnetwork          = data.google_compute_subnetwork.sub_nat_net.id
#   primary-zone        = var.primary-zone
#   tags                = ["ssh","http","https"]
#   service_account_id  = google_service_account.rehost.id
#   gcs_ansible_url     = "${google_storage_bucket.utils.url}/ansible"
#   module_depends_on       = [ module.policies, google_sql_database.app-db, google_storage_bucket.utils, google_compute_network.main_network ]
# }

# module "rehost-mig" {
#   source              = "./modules/rehost-mig"
#   project_id          = module.project-factory.project_id
#   network             = google_compute_network.main_network.name
#   subnetwork          = data.google_compute_subnetwork.sub_nat_net.id
#   region              = var.region
#   primary-zone        = var.primary-zone
#   tags                = ["ssh","http","https"]
#   service_account_id  = google_service_account.rehost-mig.id
#   gcs_ansible_url     = "${google_storage_bucket.utils.url}/ansible"
#   module_depends_on   = [ module.policies, google_sql_database.app-db, google_storage_bucket.utils, google_compute_network.main_network ]
#   lb_ssl_domains       = [ local.rehost_mig_domain ]
# }


# #GKE
# module "replatform" {
#   source                  = "./modules/replatform"
#   network_name            = var.network_name
#   primary-zone            = var.primary-zone
#   project_id              = module.project-factory.project_id
#   ip_range_pods_name      = var.ip_range_pods_name
#   ip_range_services_name  = var.ip_range_services_name
#   gke_cluster_name        = "replatform"
#   module_depends_on       = [ module.policies, google_sql_database.app-db, google_storage_bucket.utils, google_compute_network.main_network ]
#   template_git            = var.template_git
#   template_path           = var.template_path
#   template_path_mainrepo  = var.template_path_mainrepo
#   kanboard_sa_name_id     = google_service_account.replatform.id
#   dns_zone                = var.dns_zone
#   dns_project_id          = var.dns_project_id
#   prefix_name             = var.project_name
# }

# module "dns" {
#   source              = "./modules/dns"
#   project_id          = var.dns_project_id # The name of the project that manages the zone
#   prefix_name         = var.project_name   # This will be used to create the zone prefix
#   dns_zone            = var.dns_zone
#   rehost_endpoint     = module.rehost.instance_ip_addr
#   rehost_mig_endpoint = module.rehost-mig.external_ip
# }

# module "anthos_config" {
#   source              = "./modules/anthos_config"
#   project_id          = module.project-factory.project_id # The name of the project that manages the zone
# }
