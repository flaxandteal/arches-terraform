resource "google_artifact_registry_repository" "repository" {
  project                = var.project_id
  repository_id          = var.repository_id
  location               = var.location
  description            = var.description
  format                 = var.format
  mode                   = var.mode
  cleanup_policy_dry_run = var.cleanup_policy_dry_run

  #security
  #kms_key_name = "projects/my-project/locations/global/keyRings/my-key-ring/cryptoKeys/my-key" sji todo
}