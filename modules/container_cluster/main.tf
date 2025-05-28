# Define the GKE cluster
resource "google_container_cluster" "cluster" {
  provider = google-beta

  name                     = var.name
  location                 = var.location
  network                  = var.network
  subnetwork               = var.subnetwork
  min_master_version       = var.min_master_version
  remove_default_node_pool = var.remove_default_node_pool

  deletion_protection = false

  # Empty node_pool block to ensure default pool is removed
  node_pool {
    name       = "default-pool"
    node_count = 0
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.ip_allocation_policy.cluster_secondary_range_name
    services_secondary_range_name = var.ip_allocation_policy.services_secondary_range_name
    stack_type                    = var.ip_allocation_policy.stack_type
    pod_cidr_overprovision_config {
      disabled = var.ip_allocation_policy.pod_cidr_overprovision_config.disabled
    }
    additional_pod_ranges_config {
      pod_range_names = var.ip_allocation_policy.additional_pod_ranges_config.pod_range_names
    }
  }

  addons_config {
    dns_cache_config {
      enabled = var.addons_config.dns_cache_config.enabled
    }
    gce_persistent_disk_csi_driver_config {
      enabled = var.addons_config.gce_persistent_disk_csi_driver_config.enabled
    }
    horizontal_pod_autoscaling {
      disabled = var.addons_config.horizontal_pod_autoscaling.disabled
    }
    http_load_balancing {
      disabled = var.addons_config.http_load_balancing.disabled
    }
    network_policy_config {
      disabled = var.addons_config.network_policy_config.disabled
    }
  }

  cluster_autoscaling {
    autoscaling_profile = var.cluster_autoscaling.autoscaling_profile
  }

  database_encryption {
    state    = var.database_encryption.state
    key_name = var.database_encryption.key_name
  }

  default_max_pods_per_node = var.default_max_pods_per_node

  default_snat_status {
    disabled = var.default_snat_status.disabled
  }

  description           = var.description
  enable_shielded_nodes = var.enable_shielded_nodes

  logging_config {
    enable_components = var.logging_config.enable_components
  }

  maintenance_policy {
    recurring_window {
      end_time   = var.maintenance_policy.recurring_window.end_time
      recurrence = var.maintenance_policy.recurring_window.recurrence
      start_time = var.maintenance_policy.recurring_window.start_time
    }
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = var.master_auth.client_certificate_config.issue_client_certificate
    }
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks_config.cidr_blocks
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }
  }

  monitoring_config {
    advanced_datapath_observability_config {
      enable_metrics = var.monitoring_config.advanced_datapath_observability_config.enable_metrics
      enable_relay   = var.monitoring_config.advanced_datapath_observability_config.enable_relay
    }
    enable_components = var.monitoring_config.enable_components
  }

  network_policy {
    enabled  = var.network_policy.enabled
    provider = var.network_policy.provider
  }

  networking_mode = var.networking_mode

  node_pool_defaults {
    node_config_defaults {
      logging_variant = var.node_pool_defaults.node_config_defaults.logging_variant
    }
  }

  notification_config {
    pubsub {
      enabled = var.notification_config.pubsub.enabled
    }
  }

  pod_security_policy_config {
    enabled = var.pod_security_policy_config.enabled
  }

  private_cluster_config {
    enable_private_nodes   = var.private_cluster_config.enable_private_nodes
    master_ipv4_cidr_block = var.private_cluster_config.master_ipv4_cidr_block
    master_global_access_config {
      enabled = var.private_cluster_config.master_global_access_config.enabled
    }
  }

  protect_config {
    workload_config {
      audit_mode = var.protect_config.workload_config.audit_mode
    }
  }

  release_channel {
    channel = var.release_channel.channel
  }

  security_posture_config {
    mode               = var.security_posture_config.mode
    vulnerability_mode = var.security_posture_config.vulnerability_mode
  }

  service_external_ips_config {
    enabled = var.service_external_ips_config.enabled
  }

  vertical_pod_autoscaling {
    enabled = var.vertical_pod_autoscaling.enabled
  }

  workload_identity_config {
    workload_pool = var.workload_identity_config.workload_pool
  }


  # sji todo
  # security settings
  # authenticator_groups_config {
  #   security_group = "group@example.com" # CKV_GCP_65
  # }

  enable_intranode_visibility = true #CKV_GCP_61

  node_config {
    metadata = {
      enable = true #CKV_GCP_69
    }
    shielded_instance_config {
      enable_secure_boot          = true #CKV_GCP_68
      enable_integrity_monitoring = true #CKV_GCP_72
    }
  }


  depends_on = [var.depends_on_container_api]
}