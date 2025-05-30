#sji keys removed following
# data "google_project" "project" {
#   project_id = var.project_id
# }

module "artifact_registry" {
  for_each               = var.repositories
  source                 = "./modules/artifact_registry"
  project_id             = var.project_id
  repository_id          = each.value.repository_id
  location               = var.location
  description            = each.value.description
  format                 = var.format
  mode                   = var.mode
  cleanup_policy_dry_run = each.value.cleanup_policy_dry_run
}

module "compute_address" {
  for_each     = var.addresses
  source       = "./modules/compute_address"
  project_id   = var.project_id
  region       = var.region
  name         = each.value.name
  address      = each.value.address
  address_type = each.value.address_type
  network_tier = each.value.network_tier
  purpose      = each.value.purpose
}

module "compute_firewall" {
  depends_on         = [module.compute_subnetwork]
  for_each           = var.firewalls
  source             = "./modules/compute_firewall"
  project_id         = var.project_id
  name               = each.value.name
  network            = each.value.network
  direction          = each.value.direction
  priority           = each.value.priority
  source_ranges      = each.value.source_ranges
  destination_ranges = each.value.destination_ranges
  target_tags        = each.value.target_tags
  allow              = each.value.allow
  description        = each.value.description
}

module "storage_bucket" {
  for_each                    = var.buckets
  source                      = "./modules/storage_bucket"
  common_labels               = var.common_labels
  project_id                  = var.project_id
  name                        = each.value.name
  location                    = each.value.location
  storage_class               = each.value.storage_class
  force_destroy               = each.value.force_destroy
  public_access_prevention    = each.value.public_access_prevention
  uniform_bucket_level_access = each.value.uniform_bucket_level_access
  cors                        = each.value.cors
  encryption                  = each.value.encryption
  logging                     = each.value.logging
}

module "service_accounts" {
  source           = "./modules/service_account"
  project_id       = var.project_id
  service_accounts = var.service_accounts
}

module "compute_network" {
  for_each                                  = var.networks
  source                                    = "./modules/compute_network"
  project_id                                = var.project_id
  name                                      = each.value.name
  auto_create_subnetworks                   = each.value.auto_create_subnetworks
  routing_mode                              = each.value.routing_mode
  network_firewall_policy_enforcement_order = each.value.network_firewall_policy_enforcement_order
}

module "compute_subnetwork" {
  for_each                   = var.subnetworks
  source                     = "./modules/compute_subnetwork"
  project_id                 = var.project_id
  name                       = each.value.name
  region                     = var.region
  network                    = each.value.network
  ip_cidr_range              = each.value.ip_cidr_range
  private_ip_google_access   = each.value.private_ip_google_access
  depends_on                 = [module.compute_network]
  private_ipv6_google_access = each.value.private_ipv6_google_access
  purpose                    = each.value.purpose
  stack_type                 = each.value.stack_type
  secondary_ip_ranges        = each.value.secondary_ip_ranges
}

module "compute_router" {
  for_each   = var.routers
  source     = "./modules/compute_router"
  project_id = var.project_id
  name       = each.value.name
  network    = each.value.network
  subnetwork = each.value.subnetwork
  region     = var.region
  depends_on = [module.compute_subnetwork]
}

module "kms_key_ring" {
  for_each         = var.kms_key_rings
  depends_on       = [module.service_accounts]
  source           = "./modules/kms"
  project_id       = var.project_id
  name             = each.value.name
  location         = each.value.location
  crypto_keys      = each.value.crypto_keys
  labels           = each.value.labels
  service_accounts = var.service_accounts
}

# Root module to manage GKE clusters and node pools for multiple environments
variable "clusters" {
  description = "Map of GKE clusters to create. Each cluster is an object containing cluster and node pool configs."
  type = map(object({
    name               = string
    location           = string
    network            = string
    subnetwork         = string
    min_master_version = string
    ip_allocation_policy = object({
      cluster_secondary_range_name  = string
      services_secondary_range_name = string
      stack_type                    = string
      pod_cidr_overprovision_config = object({
        disabled = bool
      })
      additional_pod_ranges_config = object({
        pod_range_names = list(string)
      })
    })
    addons_config = object({
      dns_cache_config                      = object({ enabled = bool })
      gce_persistent_disk_csi_driver_config = object({ enabled = bool })
      horizontal_pod_autoscaling            = object({ disabled = bool })
      http_load_balancing                   = object({ disabled = bool })
      network_policy_config                 = object({ disabled = bool })
    })
    cluster_autoscaling = object({
      autoscaling_profile = string
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
    notification_config = object({
      pubsub = object({ enabled = bool })
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
      initial_node_count = number
      max_pods_per_node  = number

      min_node_count  = number
      max_node_count  = number
      location_policy = string

      auto_repair  = bool
      auto_upgrade = bool

      max_surge       = number
      max_unavailable = number

      machine_type = string
      disk_size_gb = number
      disk_type    = string
      image_type   = string
      preemptible  = bool
      spot         = bool

      service_account = string
      oauth_scopes    = list(string)

      labels   = map(string)
      tags     = list(string)
      metadata = map(string)

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
  }))
}



# module "container_node_pools" {
#   source = "./modules/container_node_pool"

#   for_each = var.clusters

#   cluster_name = each.value.name
#   location     = each.value.location

#   node_pools                     = each.value.node_pools
#   default_network_tags           = ["gke-cluster"]
#   depends_on_container_api       = [google_project_service.container_api]
#   depends_on_container_resources = [module.container_cluster[each.key]]
# }


# Enable the container API
resource "google_project_service" "container_api" {
  project = var.project_id
  service = "container.googleapis.com"
}

module "snapshot_policy" {
  source   = "./modules/compute_resource_policy"
  for_each = var.snapshot_policies

  project_id               = var.project_id
  region                   = var.region
  name                     = each.key
  snapshot_schedule_policy = each.value
}