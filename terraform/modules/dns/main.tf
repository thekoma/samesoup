data "google_dns_managed_zone" "soup" {
  name    = var.dns_zone
  project = var.project_id
}

locals {
  basename = "${var.prefix_name}.${data.google_dns_managed_zone.soup.dns_name}"
}

resource "google_dns_record_set" "rehost" {
  name          = "rehost.${local.basename}"
  project       = var.project_id
  managed_zone  = data.google_dns_managed_zone.soup.name
  type          = "A"
  ttl           = 300
  rrdatas       = [ var.rehost_endpoint ]
}

resource "google_dns_record_set" "rehost-mig" {
  name          = "rehost-mig.${local.basename}"
  project       = var.project_id
  managed_zone  = data.google_dns_managed_zone.soup.name
  type          = "A"
  ttl           = 300
  rrdatas       = [ var.rehost_endpoint ]
}



