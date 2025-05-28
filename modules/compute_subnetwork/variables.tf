variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "name" {
  description = "The name of the Compute Subnetwork"
  type        = string
}

variable "network" {
  description = "The network for the Subnetwork"
  type        = string
}

variable "region" {
  description = "The region for the Subnetwork"
  type        = string
}

variable "ip_cidr_range" {
  description = "The primary IP CIDR range for the Subnetwork"
  type        = string
}

variable "private_ip_google_access" {
  description = "Whether private IP Google access is enabled"
  type        = bool
}

variable "private_ipv6_google_access" {
  description = "The private IPv6 Google access setting"
  type        = string
}

variable "purpose" {
  description = "The purpose of the Subnetwork (e.g., PRIVATE)"
  type        = string
}

variable "stack_type" {
  description = "The stack type (e.g., IPV4_ONLY)"
  type        = string
}

variable "secondary_ip_ranges" {
  description = "List of secondary IP ranges"
  type = list(object({
    range_name    = string
    ip_cidr_range = string
  }))
}