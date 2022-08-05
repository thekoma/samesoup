data "google_service_account" "rehost" {
  account_id = var.service_account_id
}

resource "google_compute_instance" "rehost" {
  name          = "rehost"
  machine_type  = "e2-medium"
  zone          = var.primary-zone
  project       = var.project_id
  allow_stopping_for_update = true
  service_account {
    email  = data.google_service_account.rehost.email
    scopes = ["compute-ro", "storage-rw", "logging-write", "monitoring-write", "service-control", "service-management", "pubsub", "trace", "cloud-platform"]
  }
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size = "100"
    }
  }
  network_interface {
    network     = var.network
    subnetwork  = var.subnetwork
    access_config {
      // Ephemeral public IP
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
        - gsutil cp -r ${var.gcs_ansible_url} /opt/installer
        - ansible-galaxy collection install community.postgresql maxhoesel.caddy community.general
        - ansible-galaxy install googlecloudplatform.google_cloud_ops_agents
        - ansible-playbook /opt/installer/ansible/rerun.yaml
        - sh -c /opt/installer/rerun.sh
      EOT
  }

  tags = var.tags
}


output "instance_ip_addr" {
  value = google_compute_instance.rehost.network_interface.0.access_config.0.nat_ip
}