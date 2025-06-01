variable "common_labels" {
  description = "Common labels to apply to resources"
  type        = map(string)
}

variable "gke_version" {
  description = "GKE version to use for clusters"
  type        = string
}

variable "project_id" {
  description = "The project ID to deploy resources"
  type        = string
}

variable "location" {
  description = "The location (zone or region) for resources"
  type        = string
}

variable "region" {
  description = "The region for resources"
  type        = string
}

variable "format" {
  description = "The format for artifact registries"
  type        = string
}

variable "mode" {
  description = "The mode for artifact registries"
  type        = string
}

variable "repositories" {
  description = "Map of artifact registry repositories"
  type = map(object({
    repository_id          = string
    description            = string
    cleanup_policy_dry_run = bool
  }))
}

variable "networks" {
  description = "Map of networks to create"
  type = map(object({
    name                                      = string
    project_id                                = string
    auto_create_subnetworks                   = bool
    routing_mode                              = string
    network_firewall_policy_enforcement_order = string
  }))
}

variable "subnetworks" {
  description = "Map of subnetworks to create"
  type = map(object({
    name                       = string
    project_id                 = string
    region                     = string
    network                    = string
    ip_cidr_range              = string
    private_ip_google_access   = bool
    private_ipv6_google_access = string
    purpose                    = string
    stack_type                 = string # "IPV4_ONLY", "DUAL_STACK", or "IPV6_ONLY"
    secondary_ip_ranges = optional(list(object({
      range_name    = string
      ip_cidr_range = string
    })), [])
  }))
}

variable "addresses" {
  description = "Map of compute addresses"
  type = map(object({
    name         = string
    address      = string
    address_type = string
    network_tier = string
    purpose      = string
  }))
}

variable "firewalls" {
  description = "Map of firewall rules"
  type = map(object({
    name               = string
    network            = string
    direction          = string
    priority           = number
    source_ranges      = optional(list(string), [])
    destination_ranges = optional(list(string), [])
    target_tags        = optional(list(string), [])
    allow = list(object({
      protocol = string
      ports    = optional(list(string))
    }))
    description = string
  }))
}

variable "buckets" {
  description = "Map of storage buckets"
  type = map(object({
    name                        = string
    location                    = string
    storage_class               = string
    force_destroy               = bool
    public_access_prevention    = string
    uniform_bucket_level_access = bool
    cors = optional(list(object({
      max_age_seconds = number
      method          = list(string)
      origin          = list(string)
      response_header = list(string)
    })))
    encryption = optional(object({
      default_kms_key_name = string
    }))
    logging = optional(object({
      log_bucket        = string
      log_object_prefix = string
    }))
  }))
}

variable "service_accounts" {
  description = "Map of service account configurations"
  type = map(object({
    account_id      = string
    display_name    = string
    description     = string
    allow_iam_roles = bool
    roles           = optional(list(string), [])
  }))
  default = {}
}

variable "routers" {
  description = "Map of compute routers"
  type = map(object({
    name       = string
    network    = string
    subnetwork = string
  }))
}

variable "kms_key_rings" {
  type = map(object({
    name     = string
    location = string
    crypto_keys = map(object({
      name                = string
      service_account_key = string
    }))
    labels = map(string)
  }))
}

variable "clusters" {
  description = "Map of GKE cluster configurations for different environments"
  type = map(object({
    name                     = string
    location                 = string
    node_version             = optional(string)
    min_master_version       = optional(string)
    network                  = string
    subnetwork               = string
    initial_node_count       = number
    remove_default_node_pool = bool
    node_config = object({
      disk_size_gb    = number
      disk_type       = string
      image_type      = string
      logging_variant = string
      machine_type    = string
      metadata        = map(string)
      oauth_scopes    = list(string)
      service_account = string
      shielded_instance_config = object({
        enable_integrity_monitoring = bool
      })
      workload_metadata_config = object({
        mode = string
      })
      labels = map(string)
      tags   = list(string)
    })
    ip_allocation_policy = object({
      cluster_secondary_range_name  = string
      services_secondary_range_name = string
      stack_type                    = string
      pod_cidr_overprovision_config = object({
        disabled = bool
      })
      # additional_pod_ranges_config = object({
      #   pod_range_names = list(string)
      # })
    })
    addons_config = object({
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
    cluster_autoscaling = object({
      autoscaling_profile = string
    })
    cluster_telemetry = object({
      type = string
    })
    database_encryption = object({
      state    = string
      key_name = string
    })
    default_max_pods_per_node = number
    default_snat_status = object({
      disabled = bool
    })
    description           = string
    enable_shielded_nodes = bool
    logging_config = object({
      enable_components = list(string)
    })
    maintenance_policy = object({
      recurring_window = object({
        end_time   = string
        recurrence = string
        start_time = string
      })
    })
    master_auth = object({
      client_certificate_config = object({
        issue_client_certificate = bool
      })
    })
    master_authorized_networks_config = object({
      cidr_blocks = list(object({
        cidr_block   = string
        display_name = string
      }))
    })
    monitoring_config = object({
      advanced_datapath_observability_config = object({
        enable_metrics = bool
        enable_relay   = bool
      })
      enable_components = list(string)
    })
    network_policy = object({
      enabled  = bool
      provider = string
    })
    networking_mode = string

    node_pool_defaults = object({
      node_config_defaults = object({
        logging_variant = string
      })
    })
    notification_config = object({
      pubsub = object({
        enabled = bool
      })
    })
    pod_security_policy_config = object({
      enabled = bool
    })
    private_cluster_config = object({
      enable_private_nodes   = bool
      master_ipv4_cidr_block = string
      master_global_access_config = object({
        enabled = bool
      })
    })
    protect_config = object({
      workload_config = object({
        audit_mode = string
      })
    })
    release_channel = object({
      channel = string
    })
    security_posture_config = object({
      mode               = string
      vulnerability_mode = string
    })
    service_external_ips_config = object({
      enabled = bool
    })
    vertical_pod_autoscaling = object({
      enabled = bool
    })
    workload_identity_config = object({
      workload_pool = string
    })
    node_pools = map(object({
      name               = string
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
      network_config = object({
        enable_private_nodes = bool
        pod_range            = string
      })
    }))
  }))
}

variable "snapshot_policies" {
  description = "Map of snapshot policies"
  type = map(object({
    retention_policy = object({
      max_retention_days    = number
      on_source_disk_delete = string
    })
    schedule = object({
      daily_schedule = optional(object({
        days_in_cycle = number
        start_time    = string
      }))
      hourly_schedule = optional(object({
        hours_in_cycle = number
        start_time     = string
      }))
      weekly_schedule = optional(object({
        day_of_weeks = list(object({
          day        = string
          start_time = string
        }))
      }))
    })
    snapshot_properties = object({
      labels            = map(string)
      storage_locations = list(string)
    })
  }))
  validation {
    condition = alltrue([
      for k, v in var.snapshot_policies : (
        (v.schedule.daily_schedule != null ? 1 : 0) +
        (v.schedule.hourly_schedule != null ? 1 : 0) +
        (v.schedule.weekly_schedule != null ? 1 : 0)
      ) == 1
    ])
    error_message = "Each snapshot policy must specify exactly one of daily_schedule, hourly_schedule, or weekly_schedule."
  }
}