resource "google_vpc_access_connector" "connector" {
  depends_on = [ module.enabled_google_apis ]
  name          = var.connector_name
  ip_cidr_range = var.connector_cidr
  network       = var.network
}
