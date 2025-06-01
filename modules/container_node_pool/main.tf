# Defining GKE node pools for a given cluster
resource "google_container_node_pool" "node_pool" {
  for_each = var.node_pools

  provider           = google-beta
  name               = each.value.name
  cluster            = var.cluster_name
  location           = var.location
  initial_node_count = each.value.initial_node_count
  max_pods_per_node  = each.value.max_pods_per_node

  autoscaling {
    min_node_count  = each.value.min_node_count
    max_node_count  = each.value.max_node_count
    location_policy = each.value.location_policy
  }

  management {
    auto_repair  = each.value.auto_repair
    auto_upgrade = each.value.auto_upgrade
  }

  upgrade_settings {
    max_surge       = each.value.max_surge
    max_unavailable = each.value.max_unavailable
  }

  network_config {
    enable_private_nodes = each.value.network_config.enable_private_nodes
    pod_ipv4_cidr_block  = each.value.network_config.pod_ipv4_cidr_block
    pod_range            = each.value.network_config.pod_range
  }

  node_config {
    machine_type = each.value.machine_type
    disk_size_gb = each.value.disk_size_gb
    disk_type    = each.value.disk_type
    image_type   = each.value.image_type
    preemptible  = each.value.preemptible
    spot         = each.value.spot

    service_account = var.service_account
    oauth_scopes    = var.oauth_scopes

    labels = merge(
      { "TF_used_for" = "gke", "TF_used_by" = var.cluster_name },
      each.value.labels
    )
    tags     = distinct(concat(var.default_network_tags, each.value.tags))
    metadata = each.value.metadata

    dynamic "taint" {
      for_each = each.value.node_taints
      content {
        key    = taint.value.key
        value  = taint.value.value
        effect = taint.value.effect
      }
    }

    dynamic "guest_accelerator" {
      for_each = each.value.gpu_type == null ? [] : [each.value.gpu_type]
      content {
        type  = guest_accelerator.value.type
        count = guest_accelerator.value.count
      }
    }

    shielded_instance_config {
      enable_secure_boot          = each.value.shielded_instance_config.enable_secure_boot
      enable_integrity_monitoring = each.value.shielded_instance_config.enable_integrity_monitoring
    }

    workload_metadata_config {
      mode = each.value.workload_metadata_config.mode
    }
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  #depends_on = [var.depends_on_container_api, var.depends_on_container_resources]
}