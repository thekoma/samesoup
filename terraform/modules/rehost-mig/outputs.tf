output "rehost-url" {
  value = trimsuffix(local.rehost_record, ".")
}
output "lb_ip" {
  value = google_compute_address.rehost_mig_lb.address
}