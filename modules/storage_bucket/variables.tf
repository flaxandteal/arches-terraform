variable "common_labels" {
  description = "Common labels to apply to storage resources"
  type        = map(string)
}

variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "name" {
  description = "The name of the Storage Bucket"
  type        = string
}

variable "location" {
  description = "The location of the Storage Bucket"
  type        = string
}

variable "storage_class" {
  description = "The storage class of the Storage Bucket (e.g., STANDARD)"
  type        = string
}

variable "force_destroy" {
  description = "Whether to allow force destroy of the bucket"
  type        = bool
}

variable "public_access_prevention" {
  description = "Public access prevention setting (e.g., enforced, inherited)"
  type        = string
}

variable "uniform_bucket_level_access" {
  description = "Whether uniform bucket-level access is enabled"
  type        = bool
}

variable "cors" {
  description = "CORS configuration for the bucket"
  type = list(object({
    max_age_seconds = optional(number)
    method          = list(string)
    origin          = list(string)
    response_header = optional(list(string))
  }))
  default = []
}

variable "encryption" {
  description = "Encryption configuration for the bucket"
  type = object({
    default_kms_key_name = string
  })
  default = null
}

variable "logging" {
  description = "Logging configuration for the bucket"
  type = object({
    log_bucket        = string
    log_object_prefix = string
  })
  default = null
}
#sji todo
# variable "bucket_iam_bindings" {
#   description = "List of IAM bindings for storage buckets"
#   type = list(object({
#     bucket_name = string
#     role        = string
#     members     = list(string)
#   }))
#   default = []
# }