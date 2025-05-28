# # ./modules/kms/outputs.tf
# output "key_ring_id" {
#   description = "The ID of the created KMS key ring."
#   value       = google_kms_key_ring.key_ring.id
# }

output "crypto_key_ids" {
  description = "The IDs of the created KMS crypto keys."
  value       = { for k, v in google_kms_crypto_key.crypto_key : k => v.id }
}