variable "network" {
  type     = string
}

variable "subnetwork" {
  type     = string
  default = "default"
}

variable "region" {
  type     = string
  default = "us-central1"
}

variable "location" {
  type     = string
  default = "US"
}

variable "zones" {
  type    = list(string)
  default = [
    "us-central1-a",
    "us-central1-b",
    "us-central1-c"
  ]
}

variable "primary-zone" {
  type    = string
  default = "us-central1-a"
}

variable "subnet_ip" {
  type     = string
}

variable "project_id" {
  type     = string
  nullable = false
}

variable "tags" {
  type     = list(string)
  default = [
    "ssh",
    "http",
    "https"
  ]
}
