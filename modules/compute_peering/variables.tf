variable "peering_name" {
  description = "The name of the peering connection"
  type        = string
}

variable "network_self_link" {
  description = "The self_link of the first VPC network"
  type        = string
}

variable "peer_network_self_link" {
  description = "The self_link of the peer VPC network"
  type        = string
}

variable "auto_create_routes" {
  description = "Whether to automatically create routes for the peering"
  type        = bool
  default     = true
}
