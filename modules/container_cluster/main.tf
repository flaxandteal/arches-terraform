# Define the GKE cluster
resource "google_container_cluster" "cluster" {
  provider = google-beta

  name                     = var.name
  location                 = var.location
  network                  = var.network
  subnetwork               = var.subnetwork
  min_master_version       = var.min_master_version
  remove_default_node_pool = var.remove_default_node_pool

  deletion_protection = true

  # Empty node_pool block to ensure default pool is removed
  node_pool {
    name       = "default-pool"
    node_count = 0
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.ip_allocation_policy.cluster_secondary_range_name
    services_secondary_range_name = var.ip_allocation_policy.services_secondary_range_name
    stack_type                    = var.ip_allocation_policy.stack_type
    dynamic "pod_cidr_overprovision_config" {
      for_each = var.ip_allocation_policy.pod_cidr_overprovision_config != null ? [var.ip_allocation_policy.pod_cidr_overprovision_config] : []
      content {
        disabled = pod_cidr_overprovision_config.value.disabled
      }
    }
    # dynamic "additional_pod_ranges_config" {
    #   for_each = length(var.ip_allocation_policy.additional_pod_ranges_config.pod_range_names) > 0 ? [var.ip_allocation_policy.additional_pod_ranges_config] : []
    #   content {
    #     pod_range_names = additional_pod_ranges_config.value.pod_range_names
    #   }
    # }
  }

  dynamic "addons_config" {
    for_each = var.addons_config != null ? [var.addons_config] : []
    content {
      dynamic "dns_cache_config" {
        for_each = addons_config.value.dns_cache_config != null ? [addons_config.value.dns_cache_config] : []
        content {
          enabled = dns_cache_config.value.enabled
        }
      }
      dynamic "gce_persistent_disk_csi_driver_config" {
        for_each = addons_config.value.gce_persistent_disk_csi_driver_config != null ? [addons_config.value.gce_persistent_disk_csi_driver_config] : []
        content {
          enabled = gce_persistent_disk_csi_driver_config.value.enabled
        }
      }
      horizontal_pod_autoscaling { disabled = addons_config.value.horizontal_pod_autoscaling.disabled }
      http_load_balancing { disabled = addons_config.value.http_load_balancing.disabled }
      network_policy_config { disabled = addons_config.value.network_policy_config.disabled }
    }
  }

  dynamic "cluster_autoscaling" {
    for_each = var.cluster_autoscaling != null ? [var.cluster_autoscaling] : []
    content {
      autoscaling_profile = cluster_autoscaling.value.autoscaling_profile
    }
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

  dynamic "node_pool_defaults" {
    for_each = var.node_pool_defaults != null ? [var.node_pool_defaults] : []
    content {
      node_config_defaults {
        logging_variant = node_pool_defaults.value.node_config_defaults.logging_variant
      }
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
    enable_private_endpoint     = var.private_cluster_config.enable_private_endpoint
    enable_private_nodes        = var.private_cluster_config.enable_private_nodes
    private_endpoint_subnetwork = var.private_cluster_config.private_endpoint_subnetwork
    master_ipv4_cidr_block      = var.private_cluster_config.master_ipv4_cidr_block
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

  #depends_on = [var.depends_on_container_api]
}