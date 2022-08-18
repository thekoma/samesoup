# Those modules are to be satisfied in the exact order or everything will break.
module "network" {
  source              = "./modules/network"
  project_id          = local.project_id
  region              = var.region
  network_name        = var.network_name
  module_depends_on   = [ module.project-factory ]
}

module "policies" {
  source              = "./modules/policies"
  project_id          = local.project_id
  module_depends_on   = [ module.project-factory, module.network ]
}

module "database" {
  source              = "./modules/database"
  project_id          = local.project_id
  region              = var.region
  network_name        = var.network_name
  module_depends_on   = [ module.project-factory, module.network, module.policies ]
}

module "repos" {
  source                = "./modules/repos"
  project_id            = local.project_id
  region                = var.region
  location              = var.location
  postgres_password     = module.database.db_password
  postgres_user         = module.database.db_username
  postgres_db_name      = module.database.db_name
  postgres_db_hostname  = module.database.db_hostname
  module_depends_on   = [ module.project-factory, module.network, module.policies ]
}

module "rehost" {
  source                  = "./modules/rehost"
  project_id              = local.project_id
  zone                    = var.primary-zone
  network                 = module.network.main_network_name
  subnetwork              = module.network.main_subnetwork_name
  gcs_repo_url            = module.repos.gcs_repo_url
  gcs_repo_url_secret_id  = module.repos.gcs_repo_url_secret_id
  gcs_repo_name           = module.repos.gcs_repo_name
  gcs_repo_name_secret_id = module.repos.gcs_repo_name_secret_id
  php_config_secret_id    = module.repos.php_config_secret_id

  dns_zone                = var.dns_zone
  dns_project_id          = var.dns_project_id
  dns_prefix              = var.dns_prefix

  module_depends_on       = [ module.project-factory, module.network, module.policies ]
}

module "rehost-mig" {
  source                  = "./modules/rehost-mig"
  project_id              = local.project_id
  region                  = var.region
  network                 = module.network.main_network_name
  subnetwork              = module.network.main_subnetwork_name
  gcs_repo_url            = module.repos.gcs_repo_url
  gcs_repo_url_secret_id  = module.repos.gcs_repo_url_secret_id
  gcs_repo_name           = module.repos.gcs_repo_name
  gcs_repo_name_secret_id = module.repos.gcs_repo_name_secret_id
  php_config_secret_id    = module.repos.php_config_secret_id
  dns_zone                = var.dns_zone
  dns_project_id          = var.dns_project_id
  dns_prefix              = var.dns_prefix
  module_depends_on       = [ module.project-factory, module.network, module.policies ]
}

module "replatform" {
  source                  = "./modules/replatform"
  project_id              = local.project_id
  region                  = var.region
  network                 = module.network.main_network_name
  subnetwork              = module.network.main_subnetwork_name
  php_config_secret_id    = module.repos.php_config_secret_id
  dns_zone                = var.dns_zone
  dns_project_id          = var.dns_project_id
  dns_prefix              = var.dns_prefix
  module_depends_on       = [ module.project-factory, module.network, module.policies ]
}

module "refactor" {
  source                  = "./modules/refactor"
  project_id              = local.project_id
  region                  = var.region
  network                 = module.network.main_network_name
  php_config_secret_id    = module.repos.php_config_secret_id
  db_connection_name      = module.database.db_connection_name
  dns_zone                = var.dns_zone
  dns_project_id          = var.dns_project_id
  dns_prefix              = var.dns_prefix
  module_depends_on       = [ module.project-factory, module.network, module.policies ]
}