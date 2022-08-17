variable "module_depends_on" {
  # the value doesn't matter; we're just using this variable
  # to propagate dependencies.
  type    = any
  default = []
}

variable "project_id" {
  # the value doesn't matter; we're just using this variable
  # to propagate dependencies.
  type    = string
  nullable = false
}

variable "network_name" {
  type    = string
  nullable = false
  default = "default"
}

variable "region" {
  type    = string
  nullable = false
}
