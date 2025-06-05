resource "google_backup_dr_backup_vault" "vm_backup" {
  location                                   = var.gcp_region
  project                                    = var.gcp_project_id
  description                                = "VMs backup vault (TF managed)"
  backup_vault_id                            = "vm-backup"
  backup_minimum_enforced_retention_duration = "604800s" # 7 days
  ignore_inactive_datasources                = "true"
  access_restriction                         = "WITHIN_PROJECT"
}

resource "google_backup_dr_backup_plan" "vm_backup" {
  location       = var.gcp_region
  project        = var.gcp_project_id
  backup_plan_id = "vm-backup"
  resource_type  = "compute.googleapis.com/Instance"
  backup_vault   = google_backup_dr_backup_vault.vm_backup.id
  description    = "Daily VMs backup plan (TF managed)"

  backup_rules {
    rule_id               = "daily"
    backup_retention_days = 7

    standard_schedule {
      recurrence_type = "DAILY"
      time_zone       = "UTC"

      backup_window {
        start_hour_of_day = 0
        end_hour_of_day   = 5
      }
    }
  }
}

resource "google_backup_dr_backup_plan_association" "vm_backup" {
  for_each                   = local.vm_backups
  location                   = var.gcp_region
  project                    = var.gcp_project_id
  resource_type              = "compute.googleapis.com/Instance"
  backup_plan_association_id = each.key
  resource                   = module.vm[each.key].id
  backup_plan                = "projects/${var.gcp_project_id}/locations/${var.gcp_region}/backupPlans/${each.value}"
}
