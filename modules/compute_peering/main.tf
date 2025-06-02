resource "google_compute_network_peering" "peer1" {
  name         = var.peering_name
  network      = var.network_self_link
  peer_network = var.peer_network_self_link
}
