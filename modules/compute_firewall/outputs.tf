output "firewall_name" {
  description = "The name of the created Firewall rule"
  value       = google_compute_firewall.firewall.name
}