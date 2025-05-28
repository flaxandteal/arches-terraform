output "policy_name" {
  description = "The name of the created Compute Resource Policy"
  value       = google_compute_resource_policy.policy.name
}