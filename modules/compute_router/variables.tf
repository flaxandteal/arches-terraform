variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "name" {
  description = "The name of the Compute Router"
  type        = string
}

variable "network" {
  description = "The network for the Router"
  type        = string
}

variable "subnetwork" {
  type = string
}

variable "region" {
  description = "The region for the Router"
  type        = string
}