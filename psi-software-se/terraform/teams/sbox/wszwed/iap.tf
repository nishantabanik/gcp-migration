module "project" {
  source = "git@gitlab.com:psi-software-se/terraform/modules.git//project?ref=stable"
  billing_account = null
  parent = null
  name = var.gcp_project_id
  # services = [
    # "run.googleapis.com",
    # "compute.googleapis.com",
    # "iap.googleapis.com"
  # ]
  project_create = false
}

# Identity-Aware Proxy (IAP) or OAuth brand (see OAuth consent screen)
# Note:
# Only "Organization Internal" brands can be created programmatically
# via API. To convert it into an external brand please use the GCP
# Console.
# Brands can only be created once for a Google Cloud project and the
# underlying Google API doesn't support DELETE or PATCH methods.
# Destroying a Terraform-managed Brand will remove it from state but
# will not delete it from Google Cloud.
resource "google_iap_brand" "iap_brand" {
  count   = 1
  project = module.project.project_id
  # Support email displayed on the OAuth consent screen. The caller must be
  # the user with the associated email address, or if a group email is
  # specified, the caller can be either a user or a service account which
  # is an owner of the specified group in Cloud Identity.
  # support_email     = var.iap.email
  support_email = "psi-de-0-sb-sbox-wszwed-0@psi-de-0-sbox-wszwed.iam.gserviceaccount.com"
  application_title = var.iap.app_title
}

# IAP owned OAuth2 client
# Note:
# Only internal org clients can be created via declarative tools.
# External clients must be manually created via the GCP console.
# Warning:
# All arguments including secret will be stored in the raw state as plain-text.
resource "google_iap_client" "iap_client" {
  count        = 1
  display_name = var.iap.oauth2_client_name
  brand        = google_iap_brand.iap_brand[0].name
}

# IAM policy for IAP
# For simplicity we use the same email as support_email and authorized member
resource "google_iap_web_iam_member" "iap_iam" {
  count   = 1
  project = module.project.project_id
  role    = "roles/iap.httpsResourceAccessor"
  member  = "user:${var.iap.email}"
}

# SA service agent for IAP, which invokes CR
# Note:
# Once created, this resource cannot be updated or destroyed. These actions are a no-op.
resource "google_project_service_identity" "iap_sa" {
  provider = google-beta
  count    = 1
  project  = module.project.project_id
  service  = "iap.googleapis.com"
}
