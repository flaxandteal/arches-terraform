#sji keys removed following
# data "google_project" "project" {
#   project_id = var.project_id
# }

module "artifact_registry" {
  for_each               = var.repositories
  depends_on             = [google_project_service.artifactregistry_api]
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
  depends_on   = [google_project_service.compute_api]
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
  for_each           = var.firewalls
  depends_on         = [module.compute_network, google_project_service.compute_api]
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
  depends_on                  = [google_project_service.storage_api, module.kms_key_ring] # Added kms_key_ring in case any bucket uses KMS
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
  soft_delete_policy          = each.value.soft_delete_policy
  logging                     = each.value.logging
}

module "service_accounts" {
  source           = "./modules/service_account"
  depends_on       = [google_project_service.iam_api]
  project_id       = var.project_id
  service_accounts = var.service_accounts
}

module "compute_network" {
  for_each                                  = var.networks
  source                                    = "./modules/compute_network"
  depends_on                                = [google_project_service.compute_api]
  project_id                                = var.project_id
  name                                      = each.value.name
  auto_create_subnetworks                   = each.value.auto_create_subnetworks
  routing_mode                              = each.value.routing_mode
  network_firewall_policy_enforcement_order = each.value.network_firewall_policy_enforcement_order
}

module "compute_subnetwork" {
  for_each                   = var.subnetworks
  depends_on                 = [module.compute_network, google_project_service.compute_api]
  source                     = "./modules/compute_subnetwork"
  project_id                 = var.project_id
  name                       = each.value.name
  region                     = var.region
  network                    = module.compute_network[each.value.network].network_self_link
  ip_cidr_range              = each.value.ip_cidr_range
  private_ip_google_access   = each.value.private_ip_google_access
  private_ipv6_google_access = each.value.private_ipv6_google_access
  purpose                    = each.value.purpose
  stack_type                 = each.value.stack_type
  secondary_ip_ranges        = each.value.secondary_ip_ranges
}

module "compute_router" {
  for_each   = var.routers
  depends_on = [module.compute_subnetwork, google_project_service.compute_api]
  source     = "./modules/compute_router"
  project_id = var.project_id
  name       = each.value.name
  network    = each.value.network
  region     = var.region
}

module "kms_key_ring" {
  for_each         = var.kms_key_rings
  source           = "./modules/kms"
  depends_on       = [google_project_service.kms_api, module.service_accounts]
  project_id       = var.project_id
  name             = each.value.name
  location         = each.value.location
  crypto_keys      = each.value.crypto_keys
  labels           = each.value.labels
  service_accounts = var.service_accounts
}

# Root module to manage GKE clusters and node pools for multiple environments
module "container_cluster" {
  source = "./modules/container_cluster"
  depends_on = [
    module.compute_subnetwork,
    module.compute_router, # Routers (esp. with NAT) should exist before clusters that might use them.
    google_project_service.container_api,
    module.kms_key_ring # If database_encryption.key_name is used
  ]

  for_each = var.clusters

  name                     = each.value.name
  location                 = each.value.location
  network                  = each.value.network
  subnetwork               = each.value.subnetwork
  min_master_version       = lookup(each.value, "min_master_version", var.gke_version)
  remove_default_node_pool = each.value.remove_default_node_pool
  ip_allocation_policy     = each.value.ip_allocation_policy
  addons_config            = each.value.addons_config
  cluster_autoscaling      = each.value.cluster_autoscaling
  #cluster_telemetry                 = each.value.cluster_telemetry
  database_encryption               = each.value.database_encryption
  default_max_pods_per_node         = each.value.default_max_pods_per_node
  default_snat_status               = each.value.default_snat_status
  description                       = each.value.description
  enable_shielded_nodes             = each.value.enable_shielded_nodes
  logging_config                    = each.value.logging_config
  maintenance_policy                = each.value.maintenance_policy
  master_auth                       = each.value.master_auth
  master_authorized_networks_config = each.value.master_authorized_networks_config
  monitoring_config                 = each.value.monitoring_config
  network_policy                    = each.value.network_policy
  networking_mode                   = each.value.networking_mode
  node_pool_defaults                = each.value.node_pool_defaults
  notification_config               = each.value.notification_config
  pod_security_policy_config        = each.value.pod_security_policy_config
  private_cluster_config            = each.value.private_cluster_config
  protect_config                    = each.value.protect_config
  release_channel                   = each.value.release_channel
  security_posture_config           = each.value.security_posture_config
  service_external_ips_config       = each.value.service_external_ips_config
  vertical_pod_autoscaling          = each.value.vertical_pod_autoscaling
  workload_identity_config          = each.value.workload_identity_config

  # depends_on_container_api = [google_project_service.container_api]
}

module "node_pools" {
  source = "./modules/container_node_pool"
  depends_on = [
    module.container_cluster,
    module.service_accounts # Because node_config.service_account is passed
  ]

  for_each        = var.clusters
  cluster_name    = module.container_cluster[each.key].cluster_name # Use output from cluster module
  location        = each.value.location
  node_version    = lookup(each.value, "node_version", var.gke_version)
  service_account = each.value.node_config.service_account
  oauth_scopes    = each.value.node_config.oauth_scopes
  workload_pool   = each.value.workload_identity_config.workload_pool
  network         = each.value.network

  subnetwork           = each.value.subnetwork
  default_network_tags = ["gke-cluster"]

  node_pools = each.value.node_pools
}

# Enable necessary APIs for the project
resource "google_project_service" "container_api" {
  project = var.project_id
  service = "container.googleapis.com"
}

resource "google_project_service" "cloudresourcemanager_api" {
  project            = var.project_id
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "compute_api" {
  project            = var.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "kms_api" {
  project            = var.project_id
  service            = "cloudkms.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "iam_api" {
  project            = var.project_id
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "artifactregistry_api" {
  project            = var.project_id
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "storage_api" {
  project            = var.project_id
  service            = "storage.googleapis.com"
  disable_on_destroy = false
}

module "snapshot_policy" {
  source     = "./modules/compute_resource_policy"
  for_each   = var.snapshot_policies
  depends_on = [google_project_service.compute_api]

  project_id               = var.project_id
  region                   = var.region
  name                     = each.key
  snapshot_schedule_policy = each.value
}