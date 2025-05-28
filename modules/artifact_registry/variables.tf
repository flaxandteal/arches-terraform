variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "repository_id" {
  description = "The ID of the Artifact Registry repository"
  type        = string
}

variable "location" {
  description = "The location of the Artifact Registry repository"
  type        = string
}

variable "description" {
  description = "Description of the Artifact Registry repository"
  type        = string
}

variable "format" {
  description = "The format of the repository (e.g., DOCKER)"
  type        = string
}

variable "mode" {
  description = "The mode of the repository (e.g., STANDARD_REPOSITORY)"
  type        = string
}

variable "cleanup_policy_dry_run" {
  description = "Whether cleanup policy dry run is enabled"
  type        = bool
}