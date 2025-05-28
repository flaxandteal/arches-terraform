variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "The region for the Compute Address"
  type        = string
}

variable "name" {
  description = "The name of the Compute Address"
  type        = string
}

variable "address" {
  description = "The static IP address"
  type        = string
}

variable "address_type" {
  description = "The type of address (e.g., EXTERNAL)"
  type        = string
}

variable "network_tier" {
  description = "The network tier for the address (e.g., PREMIUM)"
  type        = string
}

variable "purpose" {
  description = "The purpose of the address (e.g., NAT_AUTO)"
  type        = string
  default     = null
}