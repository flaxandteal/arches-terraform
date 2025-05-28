output "address" {
  description = "The IP address of the Compute Address"
  value       = google_compute_address.address.address
}