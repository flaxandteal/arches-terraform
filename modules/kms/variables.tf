variable "project_id" {
  type = string
}

variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "crypto_keys" {
  type = map(object({
    name                = string
    service_account_key = string
  }))
  description = "Map of crypto keys to create, with associated service account keys."
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to the KMS key ring."
}

variable "service_accounts" {
  description = "Map of service account configurations"
  type = map(object({
    account_id   = string
    display_name = string
    description  = string
    roles        = optional(list(string), [])
  }))
  default = {}
}