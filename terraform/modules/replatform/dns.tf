data "google_dns_managed_zone" "soup" {
  name    = var.dns_zone
  project = var.dns_project_id
}

locals {
  basename = "${var.prefix_name}.${data.google_dns_managed_zone.soup.dns_name}"
}

resource "google_dns_record_set" "replatform" {
  name          = "replatform.${local.basename}"
  project       = var.dns_project_id
  managed_zone  = data.google_dns_managed_zone.soup.name
  type          = "A"
  ttl           = 300
  rrdatas       = [ google_compute_global_address.replatform.address ]
}

resource "google_compute_global_address" "replatform" {
  project       = var.project_id
  name          = "replatform-gke"
  address_type  = "EXTERNAL"
}