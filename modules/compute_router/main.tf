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
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = var.nat.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat = var.nat.source_subnetwork_ip_ranges_to_nat

  dynamic "subnetwork" {
    for_each = var.nat.source_subnetwork_ip_ranges_to_nat == "LIST_OF_SUBNETWORKS" && var.subnetwork != null ? [1] : []
    content {
      name                    = var.subnetwork
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }

  log_config {
    enable = false
    filter = "ERRORS_ONLY"
  }
}