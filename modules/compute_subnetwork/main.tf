resource "google_compute_subnetwork" "subnetwork" {
  project                    = var.project_id
  name                       = var.name
  network                    = var.network
  region                     = var.region
  ip_cidr_range              = var.ip_cidr_range
  private_ip_google_access   = var.private_ip_google_access
  private_ipv6_google_access = var.private_ipv6_google_access
  purpose                    = var.purpose
  stack_type                 = var.stack_type

  dynamic "secondary_ip_range" {
    for_each = var.secondary_ip_ranges
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  #security settings #sji todo - is this too much will it be £££?
  #enable vpc flow logs
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.1
    metadata             = "EXCLUDE_ALL_METADATA"
  }
}