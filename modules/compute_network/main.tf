resource "google_compute_network" "network" {
  project                                   = var.project_id
  name                                      = var.name
  auto_create_subnetworks                   = var.auto_create_subnetworks
  routing_mode                              = var.routing_mode
  network_firewall_policy_enforcement_order = var.network_firewall_policy_enforcement_order
}