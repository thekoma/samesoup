resource "google_compute_instance" "rehost" {
  name         = "rehost"
  machine_type = "e2-medium"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network     = var.network_name
    subnetwork  = var.subnetwork
  }
  metadata_startup_script = "echo hi > /test.txt"

}