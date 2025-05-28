output "repository_names" {
  description = "Map of repository names created"
  value       = { for k, v in module.artifact_registry : k => v.repository_name }
}

output "compute_addresses" {
  description = "Map of Compute Address IPs"
  value       = { for k, v in module.compute_address : k => v.address }
}

output "firewall_names" {
  description = "Map of Firewall rule names created"
  value       = { for k, v in module.compute_firewall : k => v.firewall_name }
}

output "bucket_names" {
  description = "Map of Storage Bucket names created"
  value       = { for k, v in module.storage_bucket : k => v.bucket_name }
}

# output "network_names" {
#   description = "Names of Compute Networks created"
#   value = {
#     prd = module.compute_network_prd.network_name
#     stg = module.compute_network.network_name
#   }
# }

# output "subnetwork_names" {
#   description = "Names of Compute Subnetworks created"
#   value = {
#     prd = module.compute_subnetwork_prd.subnetwork_name
#     stg = module.compute_subnetwork.subnetwork_name
#   }
# }

output "router_names" {
  description = "Map of Compute Router names created"
  value       = { for k, v in module.compute_router : k => v.router_name }
}

# output "route_names" {
#   description = "Map of Compute Route names created"
#   value       = { for k, v in module.compute_route : k => v.route_name }
# }

# output "resource_policy_name" {
#   description = "Name of Compute Resource Policy created"
#   value       = module.compute_resource_policy.policy_name
# }

# output "key_ring_names" {
#   description = "Map of KMS Key Ring names created"
#   value       = { for k, v in module.kms_key_ring : k => v.key_ring_name }
# }