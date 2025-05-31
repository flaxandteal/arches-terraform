resource "google_compute_router" "router" {
  project = var.project_id
  name    = var.name
  network = var.network
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  count                          = var.nat != null ? 1 : 0
  project                        = var.project_id
  router                         = google_compute_router.router.name
  region                         = var.region
  name                           = var.nat.name
  nat_ip_allocate_option         = var.nat.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat = var.nat.source_subnetwork_ip_ranges_to_nat
}