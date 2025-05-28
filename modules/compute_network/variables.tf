variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "name" {
  description = "The name of the Compute Network"
  type        = string
}

variable "auto_create_subnetworks" {
  description = "Whether to auto-create subnetworks"
  type        = bool
}

variable "routing_mode" {
  description = "The routing mode (e.g., REGIONAL)"
  type        = string
}

variable "network_firewall_policy_enforcement_order" {
  description = "The firewall policy enforcement order"
  type        = string
}