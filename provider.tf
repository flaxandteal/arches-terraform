provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  required_version = ">= 1.5.0, < 2.0.0" # sji todo
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
    bucket = "${var.project_id}-state-store"
    #prefix = "crl-state-store" #sji todo
    #prefix = "terraform/state/${var.environment}"
  }
}