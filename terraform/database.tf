locals {
  sql-networks = [ var.subnet_ip, var.pods_subnet_ip, var.svcs_subnet_ip ]
}


resource "google_sql_database_instance" "app-db" {
  name                = local.postgres_db_name
  project             = module.project-factory.project_id
  region              = var.region
  database_version    = "POSTGRES_14"
  deletion_protection = false
  depends_on = [ module.gcp-network ]
  # settings {
  #   tier = "db-n1-standard-1"
  #   ip_configuration {

  #     dynamic "authorized_networks" {
  #       for_each = local.sql-networks
  #       iterator = sql-networks

  #       content {
  #         name  = "sql-networks-${sql-networks.key}"
  #         value = sql-networks.value
  #       }
  #     }
  #   }
  # }

  settings {
    tier = "db-custom-8-8192"
    ip_configuration {
      ipv4_enabled    = false
      # private_network = data.google_compute_network.subnet-vm.id
      private_network = google_compute_network.peering_network.id
      
    }
  }
}



resource "google_sql_database" "app-db" {
  project             = module.project-factory.project_id
  name     = "app-db"
  instance = google_sql_database_instance.app-db.name
}


resource "google_sql_user" "user-app" {
  name     = local.postgres_user
  project             = module.project-factory.project_id
  instance = google_sql_database_instance.app-db.name
  type     = "BUILT_IN"
  password = random_password.secret_key.result
}

###################^^^^

# resource "random_password" "dbpassword" {
#   length           = 16
#   special          = true
#   override_special = "_%@"
#   keepers = { project_id = "${var.project_id}-${random_id.project.hex}" }
#   depends_on = [ module.project-services ]
# }

# resource "google_sql_user" "users" {
#   instance = google_sql_database_instance.ftp.name
#   name     = var.sqlusername
#   password = random_password.dbpassword.result
# }