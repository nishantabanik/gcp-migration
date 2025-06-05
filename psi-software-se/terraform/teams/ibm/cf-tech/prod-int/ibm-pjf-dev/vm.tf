module "vm" {
  for_each      = local.vm_configs
  source        = "git@gitlab.com:psi-software-se/terraform/modules.git//compute-vm?ref=stable"
  project_id    = var.gcp_project_id
  zone          = each.value.zone
  name          = each.key
  description   = each.value.description
  instance_type = each.value.instance_type
  network_interfaces = [{
    network    = var.gcp_network
    subnetwork = var.gcp_subnetwork
  }]
  service_account        = local.service_accounts[each.value.service_account]
  service_account_scopes = each.value.service_account_scopes
  iam = {
    "roles/compute.osAdminLogin" = [
      "group:app-gcp-cft@psi.de"
    ]
  }
  boot_disk = {
    auto_delete = each.value.boot_disk.auto_delete
    initialize_params = {
      image = each.value.boot_disk.image
      size  = each.value.boot_disk.size
      type  = each.value.boot_disk.type
    }
  }
  options = {
    deletion_protection = each.value.deletion_protection
  }
}
