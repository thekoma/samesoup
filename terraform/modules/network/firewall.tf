resource "google_compute_firewall" "enable_iap" {
  project     = var.project_id
  name        = "permit-iap"
  network     = google_compute_network.main_network.id
  description = "Permit SSH and RDP to hosts via IAP"

  allow {
    protocol  = "tcp"
    ports     = ["22", "3389"]
  }
  source_ranges = [ "35.235.240.0/20" ]
  target_tags = ["ssh", "rdp"]
}

resource "google_compute_firewall" "google_probes" {
  project     = var.project_id
  name        = "permit-google-probes"
  network     = google_compute_network.main_network.id
  description = "Permit HTTP/S to hosts"
  allow {
    protocol  = "all"
  }
  source_ranges = [ "130.211.0.0/22", "35.191.0.0/16" ]
}

resource "google_compute_firewall" "enable_http_https" {
  project     = var.project_id
  name        = "permit-http-https"
  network     = google_compute_network.main_network.id
  description = "Permit HTTP/S to hosts"

  allow {
    protocol  = "tcp"
    ports     = ["80", "443"]
  }
  source_ranges = [ "0.0.0.0/0" ]
  target_tags = ["http", "https"]
}