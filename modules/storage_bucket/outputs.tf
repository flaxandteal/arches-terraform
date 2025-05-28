output "bucket_name" {
  description = "The name of the created Storage Bucket"
  value       = google_storage_bucket.bucket.name
}