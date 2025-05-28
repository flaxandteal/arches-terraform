variable "project_id" {
  type        = string
  description = "The GCP Project ID."
}

variable "service_accounts" {
  description = "Map of service account configurations"
  type = map(object({
    account_id      = string
    display_name    = string
    description     = string
    allow_iam_roles = bool
    roles           = optional(list(string), [])
  }))
  default = {}
}