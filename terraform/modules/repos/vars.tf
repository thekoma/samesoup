# Data Input

variable "module_depends_on" {
  # the value doesn't matter; we're just using this variable
  # to propagate dependencies.
  type    = any
  default = []
}
variable "project_id" {
  type    = string
  nullable = false
}

variable "location" {
  type    = string
  nullable = true
  default = "US"
}


variable "postgres_password" {
  type = string
  nullable = false
}


### PostgreSQL User
variable "postgres_user" {
  type = string
  nullable = false
}

### PostgreSQL DB Name

variable "postgres_db_name" {
  type = string
  nullable = false
}

### PostgreSQL DB Hostname
variable "postgres_db_hostname" {
  type = string
  nullable = false
}


### GCS Name
variable "gcs_repo_name" {
  type = string
  nullable = true
  default = null
}

resource "random_string" "gcs_repo_name_suffix" {
  length           = 5
  special          = false
  lower            = true
  upper            = false
}

locals {
  gcs_repo_name = var.gcs_repo_name == null ? "soup-demo-${random_string.gcs_repo_name_suffix.result}" : var.gcs_repo_name
}


### GCS SVC Account Login in S3 compatible mode
variable "gcs_kanboard_svc_account_id" {
  type = string
  nullable = true
  default = "kanboard-gcs"
}

variable "php_config_secret_id" {
  type = string
  nullable = true
  default = "config_php"
}


variable "hmac_secret_key_secret_id" {
  type = string
  nullable = true
  default = "hmac_secret_key"
}

variable "hmac_secret_id_secret_id" {
  type = string
  nullable = true
  default = "hmac_secret_id"
}

variable "gcs_repo_name_secret_id" {
  type = string
  nullable = true
  default = "gcs_repo_name"
}

variable "gcs_repo_url_secret_id" {
  type = string
  nullable = true
  default = "gcs_repo_url"
}
