output "dns_config" {
  value = {
    for record, data in local.dns_config :
    format("%s.%s.%s", trimprefix(record, "A "), var.gcp_subdomain, var.gcp_domain) => data.records[0]
  }
  sensitive = false
}

output "service_accounts" {
  value     = local.service_accounts
  sensitive = false
}

output "vm_configs" {
  value     = local.vm_configs
  sensitive = false
}
