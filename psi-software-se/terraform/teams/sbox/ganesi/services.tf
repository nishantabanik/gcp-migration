# API's  required by web-proxy
resource "google_project_service" "services" {
  for_each           = toset(var.gcp_services)
  project            = var.gcp_project_id
  service            = each.value
  disable_on_destroy = false
}