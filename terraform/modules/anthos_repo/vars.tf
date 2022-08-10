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

variable "service_account" {
  type     = string
  nullable = true
  default  = "soup"
}

variable "template_git" {
  type = string
  default = "https://github.com/thekoma/samesoup"
}

variable "template_path" {
  type = string
  default = "anthos_template"
}