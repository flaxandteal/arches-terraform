output "repository_name" {
  description = "The name of the created Artifact Registry repository"
  value       = google_artifact_registry_repository.repository.name
}