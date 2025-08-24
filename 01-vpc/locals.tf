locals {
  name_prefix = "core-net"

  labels = {
    project = var.project_id
    owner   = "terraform"
    env     = "demo"
  }

  tags = {
    public  = "public-subnet"
    private = "private-subnet"
  }
}
