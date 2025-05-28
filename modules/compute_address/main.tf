resource "google_compute_address" "address" {
  project      = var.project_id
  region       = var.region
  name         = var.name
  address      = var.address
  address_type = var.address_type
  network_tier = var.network_tier
  purpose      = var.purpose
}