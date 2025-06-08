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

variable "region" {
  description = "The region for the Router"
  type        = string
}

variable "nat" {
  description = "Optional Cloud NAT configuration"
  type = object({
    name                               = string
    nat_ip_allocate_option             = string
    source_subnetwork_ip_ranges_to_nat = string
  })
  default = null
}