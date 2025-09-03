########################################
# Locals for compute_main.tf
########################################

locals {
  public_tag = local.tags.public

  labels = {
    environment = "dev"
    owner       = "team"
  }

  vm_labels = merge(local.labels, {
    component = "public-vm"
  })
}
