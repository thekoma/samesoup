data "google_compute_network" "main_network" {
  project  = var.project_id
  name     = var.network_name
}

resource "google_sql_database_instance" "app_db" {
  name                = var.postgres_db_name_value
  project             = var.project_id
  region              = var.region
  database_version    = var.postgres_version
  deletion_protection = false
  settings {
    tier = var.postgres_tier
    ip_configuration {
      ipv4_enabled    = false
      private_network = data.google_compute_network.main_network.id
    }
  }
}

resource "google_sql_database" "app_db" {
  project  = var.project_id
  name     = var.postgres_db_name_value
  instance = google_sql_database_instance.app_db.name
}

resource "google_sql_user" "user_app" {
  project  = var.project_id
  name     = var.postgres_user_value
  instance = google_sql_database_instance.app_db.name
  type     = "BUILT_IN"
  password = local.postgres_password_value
}
