output "node_pool_names" {
  description = "Names of the created node pools"
  value       = { for k, v in google_container_node_pool.node_pool : k => v.name }
}