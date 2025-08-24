output "vpc_name" {
  value       = google_compute_network.vpc.name
  description = "Name of the created VPC"
}

output "vpc_id" {
  value       = google_compute_network.vpc.id
  description = "Self link of the created VPC"
}

output "public_subnet" {
  value       = google_compute_subnetwork.public.name
  description = "Public subnet name"
}

output "private_subnet_a" {
  value       = google_compute_subnetwork.private_a.name
  description = "Private subnet A name"
}

output "private_subnet_b" {
  value       = google_compute_subnetwork.private_b.name
  description = "Private subnet B name"
}

output "cloud_router" {
  value       = google_compute_router.this.name
  description = "Cloud Router name"
}

output "cloud_nat" {
  value       = google_compute_router_nat.private_nat.name
  description = "Cloud NAT name"
}
