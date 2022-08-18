# # I need a SVC account in IAM that has the right roles to work with the repository


resource "google_compute_address" "rehost" {
  name = "rehost-ip"
}
resource "google_compute_instance" "rehost" {
  depends_on = [ google_secret_manager_secret_iam_member.php_config_secret_id ]
  name          = var.vm_name
  machine_type  = var.machine_type
  zone          = var.zone
  project       = var.project_id
  allow_stopping_for_update = true
  service_account {
    email  = google_service_account.rehost.email
    scopes = var.scopes
  }
  boot_disk {
    initialize_params {
      image = local.image_flavor
      size  = var.boot_disk_size
    }
  }
  network_interface {
    network     = var.network
    subnetwork  = var.subnetwork
    access_config {
      nat_ip = google_compute_address.rehost.address
    }
  }

  metadata = {
    enable-oslogin = "TRUE"
    user-data      = <<EOT
        #cloud-config
        packages: ["ansible", "expect"]
        write_files:
        - path: /etc/ansible/ansible.cfg
          content: |
              [defaults]
              remote_tmp     = /tmp
              local_tmp      = /tmp
        runcmd:
        - mkdir -p /opt/installer/logs
        - gsutil rsync -r ${var.gcs_repo_url} /opt/installer/
        - ansible-galaxy collection install community.postgresql maxhoesel.caddy community.general
        - ansible-galaxy install googlecloudplatform.google_cloud_ops_agents
        - ansible-playbook /opt/installer/ansible/rerun.yaml --extra-vars "url=${trimsuffix(local.rehost_record, ".")} gcs_repo=${var.gcs_repo_url} php_config_secret_id=${var.php_config_secret_id}"
        - sh -c /opt/installer/rerun.sh
      EOT
  }

  tags = var.tags
}


