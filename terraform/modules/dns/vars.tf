variable "module_depends_on" {
  # the value doesn't matter; we're just using this variable
  # to propagate dependencies.
  type    = any
  default = []
}
variable "project_id" {
  type     = string
  nullable = false
}
variable "dns_zone" {
  type     = string
  nullable = false
}

variable "refactor_endpoint" {
  type     = string
  nullable = true
  default = "8.8.8.8"
}


variable "rehost_endpoint" {
  type     = string
  nullable = true
  default = "8.8.8.8"
}

variable "rehost_mig_endpoint" {
  type     = string
  nullable = true
  default = "8.8.8.8"
}

variable "replatform_endpoint" {
  type     = string
  nullable = true
  default = "8.8.8.8"
}

variable "prefix_name" {
  type     = string
  nullable = true
  default = "soup"
}


