resource "google_compute_resource_policy" "policy" {
  project = var.project_id
  name    = var.name
  region  = var.region

  snapshot_schedule_policy {
    retention_policy {
      max_retention_days    = var.snapshot_schedule_policy.retention_policy.max_retention_days
      on_source_disk_delete = var.snapshot_schedule_policy.retention_policy.on_source_disk_delete
    }
    schedule {
      daily_schedule {
        days_in_cycle = var.snapshot_schedule_policy.schedule.daily_schedule.days_in_cycle
        start_time    = var.snapshot_schedule_policy.schedule.daily_schedule.start_time
      }
    }
    snapshot_properties {
      labels            = var.snapshot_schedule_policy.snapshot_properties.labels
      storage_locations = var.snapshot_schedule_policy.snapshot_properties.storage_locations
    }
  }
}