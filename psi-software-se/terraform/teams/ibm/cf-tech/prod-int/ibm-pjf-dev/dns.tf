# expected addresses: *.pjf.legacy.gcp.psi.de
module "dns" {
  source      = "git@gitlab.com:psi-software-se/terraform/modules.git//dns?ref=stable"
  project_id  = var.gcp_project_id
  type        = "private"
  name        = var.gcp_subdomain
  zone_create = false # zone specified with "name" property should already exist
  domain      = "${var.gcp_subdomain}.${var.gcp_domain}."
  recordsets  = local.dns_config
}
