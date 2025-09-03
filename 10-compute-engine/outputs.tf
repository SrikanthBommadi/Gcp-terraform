########################################
# Outputs for the public VM
########################################

output "public_vm_external_ip" {
  description = "External IP of the public VM"
  value       = google_compute_instance.public_vm.network_interface[0].access_config[0].nat_ip
}

output "public_vm_internal_ip" {
  description = "Internal IP of the public VM"
  value       = google_compute_instance.public_vm.network_interface[0].network_ip
}

output "public_vm_name" {
  description = "Name of the public VM"
  value       = google_compute_instance.public_vm.name
}

output "public_vm_zone" {
  description = "Zone of the public VM"
  value       = google_compute_instance.public_vm.zone
}
