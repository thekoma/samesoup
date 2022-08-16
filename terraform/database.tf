resource "google_sql_database_instance" "app-db" {
  name                = local.postgres_db_name
  project             = module.project-factory.project_id
  region              = var.region
  database_version    = "POSTGRES_14"
  deletion_protection = false
  settings {
    tier = "db-custom-8-8192"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.main-network.id
    }
  }
}
resource "google_sql_database" "app-db" {
  project             = module.project-factory.project_id
  name     = local.postgres_db_name
  instance = google_sql_database_instance.app-db.name
}
resource "google_sql_user" "user-app" {
  name     = local.postgres_user
  project             = module.project-factory.project_id
  instance = google_sql_database_instance.app-db.name
  type     = "BUILT_IN"
  password = random_password.postgress_password.result
}
