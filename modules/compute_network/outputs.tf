output "network_name" {
  description = "The name of the created Compute Network"
  value       = google_compute_network.network.name
}

output "network_self_link" {
  description = "The self-link of the created Compute Network"
  value       = google_compute_network.network.self_link
}