resource "random_password" "postgress_password" {
  length           = 16
  special          = false
}

resource "google_secret_manager_secret" "postgress_password" {
  project = module.project-factory.project_id
  secret_id = "postgress-password"
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "postgress_password" {
  secret = google_secret_manager_secret.postgress_password.id
  secret_data = random_password.postgress_password.result
}

resource "google_secret_manager_secret_iam_binding" "postgress_password" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.postgress_password.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}"
  ]
}

########


resource "google_secret_manager_secret" "postgres_user" {
  project = module.project-factory.project_id
  secret_id = "postgress-user"
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "postgres_user" {
  secret = google_secret_manager_secret.postgres_user.id
  secret_data = local.postgres_user
}

resource "google_secret_manager_secret_iam_binding" "postgres_user" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.postgres_user.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}"
  ]
}

########



resource "google_secret_manager_secret" "postgres_db_name" {
  project = module.project-factory.project_id
  secret_id = "postgress-db-name"
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "postgres_db_name" {
  secret = google_secret_manager_secret.postgres_db_name.id
  secret_data = local.postgres_db_name
}

resource "google_secret_manager_secret_iam_binding" "postgres_db_name" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.postgres_db_name.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}"
  ]
}

#######


resource "random_password" "secret_key" {
  length           = 32
  special          = false
}

resource "google_secret_manager_secret" "secret_key" {
  project = module.project-factory.project_id
  secret_id = "secret-key"
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "secret_key" {
  secret = google_secret_manager_secret.secret_key.id
  secret_data = random_password.secret_key.result
}

resource "google_secret_manager_secret_iam_binding" "secret_key" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.secret_key.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}"
  ]
}





resource "google_secret_manager_secret" "db_host" {
  project = module.project-factory.project_id
  secret_id = "db-host"
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "db_host" {
  secret = google_secret_manager_secret.db_host.id
  secret_data = google_sql_database_instance.app-db.private_ip_address
}

resource "google_secret_manager_secret_iam_binding" "db_host" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.db_host.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}"
  ]
}


resource "google_secret_manager_secret" "bucket_id" {
  project = module.project-factory.project_id
  secret_id = "bucket-id"
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "bucket_id" {
  secret = google_secret_manager_secret.bucket_id.id
  secret_data = google_storage_bucket.utils.url
}

resource "google_secret_manager_secret_iam_binding" "bucket_id" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.bucket_id.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}"
  ]
}


##########################################################################

resource "google_secret_manager_secret" "hmac_secret_id" {
  project = module.project-factory.project_id
  secret_id = "hmac_secret_id"
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}
resource "google_secret_manager_secret_version" "hmac_secret_id" {
  secret = google_secret_manager_secret.hmac_secret_id.id
  secret_data = google_storage_hmac_key.hmac_secret.access_id
}
resource "google_secret_manager_secret_iam_binding" "hmac_secret_id" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.hmac_secret_id.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}"
  ]
}





resource "google_secret_manager_secret" "hmac_secret_key" {
  project = module.project-factory.project_id
  secret_id = "hmac_secret_key"
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "hmac_secret_key" {
  secret = google_secret_manager_secret.hmac_secret_key.id
  secret_data = google_storage_hmac_key.hmac_secret.secret
}

resource "google_secret_manager_secret_iam_binding" "hmac_secret_key" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.hmac_secret_key.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}"
  ]
}



######


resource "random_password" "kanban_password" {
  length           = 16
  special          = false
}

resource "google_secret_manager_secret" "kanban_password" {
  project = module.project-factory.project_id
  secret_id = "kanban_password"
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}

resource "google_secret_manager_secret_version" "kanban_password" {
  secret = google_secret_manager_secret.kanban_password.id
  secret_data = random_password.kanban_password.result
}

resource "google_secret_manager_secret_iam_binding" "kanban_password" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.kanban_password.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}"
  ]
}



#######REHOST####

data "google_dns_managed_zone" "soup" {
  name    = var.dns_zone
  project = var.dns_project_id
}

locals {
  dns_basename = "${var.project_name}.${data.google_dns_managed_zone.soup.dns_name}"
}

resource "google_secret_manager_secret" "rehost_record" {
  project = module.project-factory.project_id
  secret_id = "rehost_record"
  replication {
    automatic = true
  }
  depends_on  = [ module.enabled_google_apis ]
}
resource "google_secret_manager_secret_version" "rehost_record" {
  secret = google_secret_manager_secret.rehost_record.id
  secret_data = "rehost.${local.dns_basename}"
}
resource "google_secret_manager_secret_iam_binding" "rehost_record" {
  project = module.project-factory.project_id
  secret_id = google_secret_manager_secret.rehost_record.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.replatform.email}",
    "serviceAccount:${google_service_account.refactor.email}",
    "serviceAccount:${google_service_account.rehost.email}"
  ]
}




######



output "kanban_password" {
  value = nonsensitive(random_password.kanban_password.result)
}