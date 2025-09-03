########################################
# Variables for compute_main.tf
########################################

variable "vm_name" {
  description = "Name of the public VM"
  type        = string
  default     = "srikanth-public-vm"
}

variable "machine_type" {
  description = "GCE machine type"
  type        = string
  default     = "e2-micro"
}

variable "zone" {
  description = "Zone for the VM (must belong to var.region)"
  type        = string
  default     = "us-central1-a"
}

variable "image" {
  description = "Boot image for the VM"
  type        = string
  default     = "projects/debian-cloud/global/images/family/debian-12"
}

variable "disk_type" {
  description = "Disk type"
  type        = string
  default     = "pd-balanced"
}

variable "disk_size_gb" {
  description = "Boot disk size (GB)"
  type        = number
  default     = 10
}

variable "startup_script" {
  description = "Optional startup script"
  type        = string
  default     = <<-EOT
    #!/usr/bin/env bash
    set -e
    apt-get update -y
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
    echo "Hello from ${HOSTNAME} on GCE" > /var/www/html/index.nginx-debian.html
  EOT
}

variable "service_account_email" {
  description = "Custom service account email (null to use default compute SA)"
  type        = string
  default     = null
}

variable "service_account_scopes" {
  description = "OAuth scopes for the VM service account"
  type        = list(string)
  default     = ["https://www.googleapis.com/auth/cloud-platform"]
}
