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

variable "region" {
  type    = string
  nullable = false
}

variable "network_name" {
  type    = string
  nullable = false
}


### PostgreSQL Password
variable "postgres_password_id" {
  type = string
  default = "postgres_password"
}

variable "postgres_password_value" {
  type = string
  nullable = true
  default = null
}

resource "random_password" "postgres_password_value" {
  length           = 16
  special          = false
}

locals {
  postgres_password_value = var.postgres_password_value == null ? random_password.postgres_password_value.result : var.postgres_password_value
}

### PostgreSQL User
variable "postgres_user_id" {
  type = string
  default = "postgres_user"
}
variable "postgres_user_value" {
  type = string
  default = "kanboard"
}

### PostgreSQL DB Name
variable "postgres_db_name_id" {
  type = string
  default = "postgres_db_name"
}
variable "postgres_db_name_value" {
  type = string
  default = "kanboard"
}

### PostgreSQL DB Hostname
variable "postgres_db_hostname_id" {
  type = string
  default = "postgres_db_hostname"
}

### PostgreSQL Parameters
variable "postgres_tier" {
  type = string
  default = "db-custom-8-8192"
}
variable "postgres_version" {
  type = string
  default = "POSTGRES_14"
}
