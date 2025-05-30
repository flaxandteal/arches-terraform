variable "node_pools" {
  type = map(object({
    machine_type       = string
    service_account    = string
    oauth_scopes       = list(string)
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
    node_taints        = list(object({
      key    = string
      value  = string
      effect = string
    }))
    gpu_type = any

    shielded_instance_config = object({
      enable_secure_boot          = bool
      enable_integrity_monitoring = bool
    })

    workload_metadata_config = object({
      mode = string
    })
  }))
}

variable "cluster_name" {
  type        = string
  description = "Name of the GKE cluster this node pool belongs to"
}

variable "location" {
  type        = string
  description = "Location (region or zone) of the GKE cluster"
}

variable "default_network_tags" {
  type        = list(string)
  description = "Default network tags to apply to nodes"
}

variable "depends_on_container_api" {
  type        = any
  description = "Dependency on enabling the container API"
}

variable "depends_on_container_resources" {
  type        = any
  description = "Dependency on cluster resources"
}
