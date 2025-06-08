resource "google_compute_router" "router" {
  project = var.project_id
  name    = var.name
  network = var.network
  region  = var.region
}

resource "google_compute_router_nat" "this" {
  count                              = var.nat == null ? 0 : 1
  name                               = var.nat.name
  project                            = var.project_id
  router                             = google_compute_router.this.name
  region                             = var.region
  nat_ip_allocate_option             = var.nat.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat = var.nat.source_subnetwork_ip_ranges_to_nat

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}