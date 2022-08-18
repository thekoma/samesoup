output "rehost-url" {
  value = trimsuffix(local.rehost_record, ".")
}
output "lb_ip" {
  value = module.mig_lb_https.external_ip
}