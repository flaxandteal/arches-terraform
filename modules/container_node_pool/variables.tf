variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "location" {
  description = "GKE cluster location (zone or region)"
  type        = string
}

variable "node_version" {
  description = "Kubernetes version for the node pool"
  type        = string
}

variable "service_account" {
  description = "Service account for the node pool"
  type        = string
}

variable "oauth_scopes" {
  description = "OAuth scopes for the node pool"
  type        = list(string)
}

variable "workload_pool" {
  description = "Workload identity pool for the node pool"
  type        = string
}

variable "network" {
  description = "VPC network for the node pool"
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork for the node pool"
  type        = string
}

variable "default_network_tags" {
  description = "Default network tags to apply to all node pools"
  type        = list(string)
  default     = []
}

# variable "depends_on_container_api" {
#   description = "Dependency on the container API enablement"
#   type        = any
#   default     = []
# }

# variable "depends_on_container_resources" {
#   description = "Dependency on the GKE cluster resources"
#   type        = any
#   default     = []
# }

variable "node_pools" {
  description = "Map of node pool configurations"
  type = map(object({
    machine_type       = string
    disk_size_gb       = number
    disk_type          = string
    image_type         = string
    auto_repair        = bool
    auto_upgrade       = bool
    min_node_count     = number
    max_node_count     = number
    initial_node_count = number
    max_pods_per_node  = number
    location_policy    = string
    max_surge          = number
    max_unavailable    = number
    preemptible        = bool
    spot               = bool
    labels             = map(string)
    tags               = list(string)
    metadata           = map(string)
    node_taints = list(object({
      key    = string
      value  = string
      effect = string
    }))
    gpu_type = object({
      type  = string
      count = number
    })
    shielded_instance_config = object({
      enable_secure_boot          = bool
      enable_integrity_monitoring = bool
    })
    workload_metadata_config = object({
      mode = string
    })
  }))
}