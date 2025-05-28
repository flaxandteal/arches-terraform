resource "google_compute_resource_policy" "policy" {
  project = var.project_id
  name    = var.name
  region  = var.region

  snapshot_schedule_policy {
    retention_policy {
      max_retention_days    = var.snapshot_schedule_policy.retention_policy.max_retention_days
      on_source_disk_delete = var.snapshot_schedule_policy.retention_policy.on_source_disk_delete
    }

    dynamic "schedule" {
      for_each = var.snapshot_schedule_policy.schedule.daily_schedule != null ? [1] : []
      content {
        daily_schedule {
          days_in_cycle = var.snapshot_schedule_policy.schedule.daily_schedule.days_in_cycle
          start_time    = var.snapshot_schedule_policy.schedule.daily_schedule.start_time
        }
      }
    }

    dynamic "schedule" {
      for_each = var.snapshot_schedule_policy.schedule.hourly_schedule != null ? [1] : []
      content {
        hourly_schedule {
          hours_in_cycle = var.snapshot_schedule_policy.schedule.hourly_schedule.hours_in_cycle
          start_time     = var.snapshot_schedule_policy.schedule.hourly_schedule.start_time
        }
      }
    }

    dynamic "schedule" {
      for_each = var.snapshot_schedule_policy.schedule.weekly_schedule != null ? [1] : []
      content {
        weekly_schedule {
          dynamic "day_of_weeks" {
            for_each = var.snapshot_schedule_policy.schedule.weekly_schedule.day_of_weeks
            content {
              day        = day_of_weeks.value.day
              start_time = day_of_weeks.value.start_time
            }
          }
        }
      }
    }

    snapshot_properties {
      labels            = var.snapshot_schedule_policy.snapshot_properties.labels
      storage_locations = var.snapshot_schedule_policy.snapshot_properties.storage_locations
    }
  }
}