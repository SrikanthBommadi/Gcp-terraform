// Networking:Custom VPC with manual subnet creation
resource "google_compute_network" "vpc" {
  name                    = "srikanth-vpc"   // fixed name
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
  description             = "Custom VPC for public and private subnets"
}

// Public subnet (instances here can have external IPs)
resource "google_compute_subnetwork" "public" {
  name          = "srikanth-public-${var.region}"
  ip_cidr_range = var.subnet_ip_ranges.public
  network       = google_compute_network.vpc.id
  region        = var.region
  description   = "Public subnet"
  private_ip_google_access = false

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

// Private subnet A
resource "google_compute_subnetwork" "private_a" {
  name          = "srikanth-private-a-${var.region}"
  ip_cidr_range = var.subnet_ip_ranges.private_a
  network       = google_compute_network.vpc.id
  region        = var.region
  description   = "Private subnet A"
  private_ip_google_access = true

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

// Private subnet B
resource "google_compute_subnetwork" "private_b" {
  name          = "srikanth-private-b-${var.region}"
  ip_cidr_range = var.subnet_ip_ranges.private_b
  network       = google_compute_network.vpc.id
  region        = var.region
  description   = "Private subnet B"
  private_ip_google_access = true

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

// ======================================
// Default Internet Route (Public VMs only)
// ======================================
resource "google_compute_route" "default_internet" {
  name             = "srikanth-default-internet"
  network          = google_compute_network.vpc.self_link
  dest_range       = "0.0.0.0/0"
  priority         = 1000
  next_hop_gateway = "default-internet-gateway"
  tags             = [local.tags.public]
  description      = "Default route to internet for public-tagged instances"

  depends_on = [google_compute_subnetwork.public]
}

// ===========================
// Cloud Router & Cloud NAT
// ===========================
resource "google_compute_router" "this" {
  name    = "srikanth-router-${var.region}"
  region  = var.region
  network = google_compute_network.vpc.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "private_nat" {
  name                               = "srikanth-nat-${var.region}"
  router                             = google_compute_router.this.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.private_a.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  subnetwork {
    name                    = google_compute_subnetwork.private_b.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

// ===========================
// Firewall Rules
// ===========================
resource "google_compute_firewall" "allow_internal" {
  name    = "srikanth-allow-internal"
  network = google_compute_network.vpc.name

  description = "Allow all traffic within the VPC"
  direction   = "INGRESS"
  priority    = 65534

  source_ranges = [
    google_compute_subnetwork.public.ip_cidr_range,
    google_compute_subnetwork.private_a.ip_cidr_range,
    google_compute_subnetwork.private_b.ip_cidr_range,
  ]

  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
}

resource "google_compute_firewall" "allow_public_ingress" {
  name    = "srikanth-allow-public-ingress"
  network = google_compute_network.vpc.name

  description = "Allow SSH, HTTP, HTTPS, ICMP to public instances"
  direction   = "INGRESS"
  priority    = 1000

  source_ranges = ["0.0.0.0/0"]
  target_tags   = [local.tags.public]

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }
  allow { protocol = "icmp" }
}

resource "google_compute_firewall" "allow_private_to_public" {
  name    = "srikanth-allow-private-to-public"
  network = google_compute_network.vpc.name

  description = "Allow private subnets to reach public subnet instances"
  direction   = "EGRESS"
  priority    = 1000

  destination_ranges = [google_compute_subnetwork.public.ip_cidr_range]
  target_tags        = [local.tags.private]

  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
}
