provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  required_version = ">= 1.5.0, < 2.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }
  backend "gcs" {
    bucket = "coral-hed-state-store"
    # backend "gcs" {} # Partial configuration using backend.hcl
    #prefix = "terraform/state/${var.environment}" sji todo
  }
}