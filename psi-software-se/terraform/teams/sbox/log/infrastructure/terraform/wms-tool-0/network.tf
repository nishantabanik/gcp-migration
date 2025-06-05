data "google_dns_managed_zone" "log" {
  name = "log"
}

module "addresses" {
  source     = "../modules/net-address"
  project_id = var.project_id
  internal_addresses = {
    backstage = {
      region     = var.region
      subnetwork = var.spoke_gke_subnetwork
      name       = "backstage"
    }
  }
}

resource "google_dns_record_set" "backstage" {
  name = "idp.${data.google_dns_managed_zone.log.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.log.name

  rrdatas    = [module.addresses.internal_addresses["backstage"].address]
  depends_on = [module.addresses]
}

# TODO: Fix hardcoded IP address
resource "google_dns_record_set" "landing_page" {
  name = "index.${data.google_dns_managed_zone.log.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.log.name

  rrdatas = ["10.95.5.79"]
}

resource "google_dns_record_set" "argocd" {
  name = "argocd.${data.google_dns_managed_zone.log.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.log.name

  rrdatas = ["10.95.5.85"]
}