resource "google_compute_firewall" "firewall" {
  project     = var.project_id
  name        = var.name
  network     = var.network
  direction   = var.direction
  priority    = var.priority
  description = var.description
  target_tags = length(var.target_tags) > 0 ? var.target_tags : null

  source_ranges      = var.source_ranges
  destination_ranges = var.destination_ranges
  #destination_ranges = var.direction == "EGRESS" ? var.destination_ranges : null

  dynamic "allow" {
    for_each = var.allow
    content {
      protocol = allow.value.protocol
      ports    = length(allow.value.ports) > 0 ? allow.value.ports : null
    }
  }
  #depends_on = [ google_compute_subnetwork.subnetwork ]
  #depends_on    = [google_container_node_pool.node_pools, google_project_service.networking_api]
}