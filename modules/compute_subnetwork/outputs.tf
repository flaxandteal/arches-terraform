output "subnetwork_name" {
  description = "The name of the created Compute Subnetwork"
  value       = google_compute_subnetwork.subnetwork.name
}