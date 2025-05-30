variable "name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "location" {
  description = "GKE cluster location (zone or region)"
  type        = string
}

variable "network" {
  description = "VPC network for the cluster"
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork for the cluster"
  type        = string
}

variable "min_master_version" {
  description = "Minimum master version for the cluster"
  type        = string
}

# variable "remove_default_node_pool" {
#   description = "Whether to remove the default node pool"
#   type        = bool
# }

variable "ip_allocation_policy" {
  description = "IP allocation policy for the cluster"
  type = object({
    cluster_ipv4_cidr_block       = string
    cluster_secondary_range_name  = string
    services_ipv4_cidr_block      = string
    services_secondary_range_name = string
    stack_type                    = string
    pod_cidr_overprovision_config = object({
      disabled = bool
    })
    additional_pod_ranges_config = object({
      pod_range_names = list(string)
    })
  })
}

variable "addons_config" {
  description = "Addons configuration for the cluster"
  type = object({
    dns_cache_config = object({
      enabled = bool
    })
    gce_persistent_disk_csi_driver_config = object({
      enabled = bool
    })
    horizontal_pod_autoscaling = object({
      disabled = bool
    })
    http_load_balancing = object({
      disabled = bool
    })
    network_policy_config = object({
      disabled = bool
    })
  })
}

variable "cluster_autoscaling" {
  description = "Cluster autoscaling configuration"
  type = object({
    autoscaling_profile = string
  })
}

variable "database_encryption" {
  description = "Database encryption configuration"
  type = object({
    state    = string
    key_name = string
  })
}

variable "default_max_pods_per_node" {
  description = "Default maximum pods per node"
  type        = number
}

variable "default_snat_status" {
  description = "Default SNAT status"
  type = object({
    disabled = bool
  })
}

variable "description" {
  description = "Description of the cluster"
  type        = string
}

variable "enable_shielded_nodes" {
  description = "Whether to enable shielded nodes"
  type        = bool
}

variable "logging_config" {
  description = "Logging configuration"
  type = object({
    enable_components = list(string)
  })
}

variable "maintenance_policy" {
  description = "Maintenance policy configuration"
  type = object({
    recurring_window = object({
      end_time   = string
      recurrence = string
      start_time = string
    })
  })
}

variable "master_auth" {
  description = "Master authentication configuration"
  type = object({
    client_certificate_config = object({
      issue_client_certificate = bool
    })
  })
}

variable "master_authorized_networks_config" {
  description = "Master authorized networks configuration"
  type = object({
    cidr_blocks = list(object({
      cidr_block   = string
      display_name = string
    }))
  })
}

variable "monitoring_config" {
  description = "Monitoring configuration"
  type = object({
    advanced_datapath_observability_config = object({
      enable_metrics = bool
      enable_relay   = bool
    })
    enable_components = list(string)
  })
}

variable "network_policy" {
  description = "Network policy configuration"
  type = object({
    enabled  = bool
    provider = string
  })
}

variable "networking_mode" {
  description = "Networking mode for the cluster"
  type        = string
}

variable "node_pool_defaults" {
  description = "Node pool defaults configuration"
  type = object({
    node_config_defaults = object({
      logging_variant = string
    })
  })
}

variable "notification_config" {
  description = "Notification configuration"
  type = object({
    pubsub = object({
      enabled = bool
    })
  })
}

variable "pod_security_policy_config" {
  description = "Pod security policy configuration"
  type = object({
    enabled = bool
  })
}

variable "private_cluster_config" {
  description = "Private cluster configuration"
  type = object({
    enable_private_nodes   = bool
    master_ipv4_cidr_block = string
    master_global_access_config = object({
      enabled = bool
    })
  })
}

variable "protect_config" {
  description = "Protect configuration"
  type = object({
    workload_config = object({
      audit_mode = string
    })
  })
}

variable "release_channel" {
  description = "Release channel configuration"
  type = object({
    channel = string
  })
}

variable "security_posture_config" {
  description = "Security posture configuration"
  type = object({
    mode               = string
    vulnerability_mode = string
  })
}

variable "service_external_ips_config" {
  description = "Service external IPs configuration"
  type = object({
    enabled = bool
  })
}

variable "vertical_pod_autoscaling" {
  description = "Vertical pod autoscaling configuration"
  type = object({
    enabled = bool
  })
}

variable "workload_identity_config" {
  description = "Workload identity configuration"
  type = object({
    workload_pool = string
  })
}

variable "depends_on_container_api" {
  description = "Dependency on the container API enablement"
  type        = any
  default     = []
}