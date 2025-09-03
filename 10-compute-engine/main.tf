########################################
# Compute Engine: Public VM (single)
########################################

resource "google_compute_instance" "public_vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = [local.public_tag]
  labels       = local.vm_labels

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size_gb
      type  = var.disk_type
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.public.self_link
    access_config {}
  }

  metadata_startup_script = var.startup_script

  service_account {
    email  = coalesce(var.service_account_email, data.google_compute_default_service_account.default.email)
    scopes = var.service_account_scopes
  }

  depends_on = [
    google_compute_network.vpc,
    google_compute_subnetwork.public,
    google_compute_firewall.allow_public_ingress
  ]
}
