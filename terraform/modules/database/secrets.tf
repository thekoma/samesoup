# PostgreSQL Password

resource "google_secret_manager_secret" "postgres_password" {
  project = var.project_id
  secret_id = var.postgres_password_id
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "postgres_password" {
  secret = google_secret_manager_secret.postgres_password.id
  secret_data = local.postgres_password_value
}

# PostgreSQL User
resource "google_secret_manager_secret" "postgres_user" {
  project = var.project_id
  secret_id = var.postgres_user_id
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "postgres_user" {
  secret = google_secret_manager_secret.postgres_user.id
  secret_data = var.postgres_user_value
}

# PostgreSQL DB Name
resource "google_secret_manager_secret" "postgres_db_name" {
  project = var.project_id
  secret_id = var.postgres_db_name_id
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "postgres_db_name" {
  secret = google_secret_manager_secret.postgres_db_name.id
  secret_data = var.postgres_db_name_value
}

# PostgreSQL DB Hostname
resource "google_secret_manager_secret" "db_host" {
  project = var.project_id
  secret_id = var.postgres_db_hostname_id
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "db_host" {
  secret = google_secret_manager_secret.db_host.id
  secret_data = google_sql_database_instance.app_db.private_ip_address
}

