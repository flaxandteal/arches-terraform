variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "name" {
  description = "The name of the Firewall rule"
  type        = string
}

variable "network" {
  description = "The network for the Firewall rule"
  type        = string
}

variable "direction" {
  description = "The direction of traffic (e.g., INGRESS)"
  type        = string
}

variable "priority" {
  description = "The priority of the Firewall rule"
  type        = number
}

variable "source_ranges" {
  description = "The source IP ranges for the Firewall rule"
  type        = list(string)
  default     = []
}

variable "destination_ranges" {
  description = "The destination IP ranges for the Firewall rule"
  type        = list(string)
  default     = []
}

variable "target_tags" {
  description = "The target tags for the Firewall rule"
  type        = list(string)
  default     = []
}

variable "description" {
  description = "Description of the Firewall rule"
  type        = string
  default     = null
}

variable "allow" {
  description = "List of allow rules for the Firewall"
  type = list(object({
    protocol = string
    ports    = optional(list(string))
  }))
}