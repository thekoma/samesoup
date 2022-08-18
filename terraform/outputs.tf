data "google_dns_managed_zone" "dns_zone" {
  name    = var.dns_zone
  project = var.dns_project_id
}
locals {
  dns_basename = "${var.dns_prefix}.${trimsuffix(data.google_dns_managed_zone.dns_zone.dns_name, ".")}"
}

output "explanation" {
  value = <<EOT
  ##### That's the SameSoup it just changes the plate. #####

  We have created a PHP application (kanban) installed in 4 different ways.
  Each installation has the same database and shares the same configuration (and so the same storage backend).
  This means that you can actually connect to any of these endpoint and it will result in the same site:
  Rehost:     https://rehost.${local.dns_basename}      <- This is a lift and shift
  ReHost-Mig: https://rehost-mig.${local.dns_basename}  <- A more complex lift and shift where the backend will autoscale on multiple hosts.
  Replatform: https://replatform.${local.dns_basename}  <- The site is now converted into a container and runs into GKE
  Refactor:   https://replatform.${local.dns_basename}  <- The end of the curve, the application is now only a container as a service in Cloud Run

  The credentials are:
  user:     admin
  password: admin

  Feel free to break it.
  EOT
}