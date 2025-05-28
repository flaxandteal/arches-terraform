variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "name" {
  description = "The name of the Compute Resource Policy"
  type        = string
}

variable "region" {
  description = "The region for the Resource Policy"
  type        = string
}

variable "snapshot_schedule_policy" {
  description = "Snapshot schedule policy configuration"
  type = object({
    retention_policy = object({
      max_retention_days    = number
      on_source_disk_delete = string
    })

    schedule = object({
      daily_schedule = optional(object({
        days_in_cycle = number
        start_time    = string
      }))

      hourly_schedule = optional(object({
        hours_in_cycle = number
        start_time     = string
      }))

      weekly_schedule = optional(object({
        day_of_weeks = list(object({
          day        = string
          start_time = string
        }))
      }))
    })

    snapshot_properties = object({
      labels            = map(string)
      storage_locations = list(string)
    })
  })
}
