resource "google_storage_bucket" "bucket" {
  provider                    = google
  project                     = var.project_id
  name                        = var.name
  location                    = var.location
  storage_class               = var.storage_class
  force_destroy               = var.force_destroy
  public_access_prevention    = var.public_access_prevention
  uniform_bucket_level_access = var.uniform_bucket_level_access

  dynamic "cors" {
    for_each = var.cors != null && length(var.cors) > 0 ? var.cors : []
    content {
      max_age_seconds = cors.value.max_age_seconds
      method          = cors.value.method
      origin          = cors.value.origin
      response_header = cors.value.response_header
    }
  }

  # dynamic "encryption" {
  #   for_each = var.encryption != null && try(var.encryption.default_kms_key_name, null) != null ? [var.encryption] : []
  #   content {
  #     default_kms_key_name = encryption.value.default_kms_key_name
  #   }
  # }

  dynamic "logging" {
    for_each = var.logging != null && try(var.logging.log_bucket, null) != null ? [var.logging] : []
    content {
      log_bucket        = logging.value.log_bucket
      log_object_prefix = logging.value.log_object_prefix
    }
  }
}
#sji todo
# resource "google_storage_bucket_iam_binding" "bucket_iam" {
#   for_each = { for binding in var.bucket_iam_bindings : "${binding.bucket_name}-${binding.role}" => binding }

#   bucket  = each.value.bucket_name
#   role    = each.value.role
#   members = each.value.members
# }