output db_hostname {
  value = google_sql_database_instance.app_db.private_ip_address
}
output db_username {
  value = var.postgres_user_value
}
output db_password {
  value = nonsensitive(local.postgres_password_value)
}
output db_name {
  value = var.postgres_db_name_value
}

output db_hostname_secret_id {
  value = var.postgres_db_hostname_id
}
output db_username_secret_id {
  value = var.postgres_user_id
}
output db_password_secret_id {
  value = var.postgres_password_id
}
output db_name_secret_id {
  value = var.postgres_db_name_id
}