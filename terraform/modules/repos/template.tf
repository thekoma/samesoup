data "template_file" "config_php" {
  template = "${file("${path.module}/template/config.php.tpl")}"
  vars = {
    db_user = var.postgres_user
    db_password = var.postgres_password
    db_name =  var.postgres_db_name
    db_hostname = var.postgres_db_hostname
    aws_key = google_storage_hmac_key.hmac_secret.access_id
    aws_secret = google_storage_hmac_key.hmac_secret.secret
    aws_bucket = google_storage_bucket.gcs_repo.name
  }
}