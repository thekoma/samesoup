resource "google_compute_instance" "rehost" {
  name          = "rehost"
  machine_type  = "e2-medium"
  zone          = var.primary-zone
  project       = var.project_id
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network     = var.network
    subnetwork  = var.subnetwork
    access_config {
      // Ephemeral public IP
    }
  }
  metadata_startup_script = "echo hi > /test.txt"
  tags = var.tags
}
