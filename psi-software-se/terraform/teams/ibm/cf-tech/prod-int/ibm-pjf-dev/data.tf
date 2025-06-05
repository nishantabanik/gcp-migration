locals {

  _vm_files_path = "data/vm"

  _vm_files = [for f in fileset(local._vm_files_path, "**/*.yaml") : f if basename(f) != "0.sample.yaml"]

  _vm_configs = {
    for f in local._vm_files :
    trimsuffix(f, ".yaml") => yamldecode(file("${local._vm_files_path}/${f}"))
  }

  vm_configs = {
    for name, data in local._vm_configs : name => {
      backup_plan = try(data.backup_plan, null)
      boot_disk = {
        auto_delete = try(data.boot_disk.auto_delete, true)
        image       = try(data.boot_disk.image, "family/debian-12")
        size        = try(data.boot_disk.size, 10)
        type        = try(data.boot_disk.type, "pd-balanced")
      }
      deletion_protection    = try(data.deletion_protection, false)
      description            = format("%s (TF managed)", data.description),
      dns_name               = try(data.dns_name, null)
      instance_type          = try(data.instance_type, "f1-micro")
      service_account        = try(data.service_account, "compute")
      service_account_scopes = try(data.service_account_scopes, ["cloud-platform"])
      zone                   = try(data.zone, var.gcp_zone)
    }
  }

  vm_backups = { for k, v in local.vm_configs : k => v.backup_plan if v.backup_plan != null }

  dns_config = { for k, v in local.vm_configs : "A ${v.dns_name}" => {
    ttl     = 300
    records = [module.vm[k].internal_ip]
  } if v.dns_name != null }

  service_accounts = {
    compute : data.google_service_account.compute.email,
    kubernetes : data.google_service_account.kubernetes.email
  }
}
