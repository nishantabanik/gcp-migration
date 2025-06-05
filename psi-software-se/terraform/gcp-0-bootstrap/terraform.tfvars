# Use `gcloud billing accounts list`
# ACCOUNT_ID            NAME
# 01470A-311B94-AF6F41  psi.de - Amex - AF6F41
# 01D8CF-992F98-D31C6F  psi.de - Invoice - D31C6F
billing_account = {
  id = "01D8CF-992F98-D31C6F"
}

# Use `gcloud organizations list`
organization = {
  domain      = "psi.de"
  id          = 337607581105
  customer_id = "C04gfoycx"
}

# Use something unique and no longer than 9 characters
# A good prefix is: [VERY-SHORT-NAME]-[NUMBER]
prefix = "psi-de-0"

# Slalom: Limitation of resources to regions in the EU
locations = {
  # Slalom: Limit GCS buckets to European Union (EU).
  #         The Terraform state and output are stored in buckets.
  #         Multi-region should be used because of fault tolerance.
  #         The location cannot be easily changed later.
  gcs = "EU"
  # Slalom: Limit log export bucket to Netherlands (https://gcloud-compute.com/europe-west4.html)
  logging = "europe-west4"
  # Slalom: Limit log export Pup/Sub to Netherlands
  pubsub = ["europe-west4"]
  # Slalom: Limit BigQuery billing export to Netherlands
  bq = "europe-west4"
  # Slalom: Limit Cloud Build location for the trigger to Netherlands
  # https://cloud.google.com/build/docs/locations#restricted_regions_for_some_projects
  trigger = "europe-west4"
}

# PSI: Configure Workload Identity Pool Provider for GitLab
federated_identity_providers = {
  # Use something unique and no longer than 9 characters
  git-psi = {
    # Restrict access to username or the name of a GitLab group
    # https://github.com/Cyclenerd/google-workload-identity-federation/blob/master/gitlab.md#gitlab-oidc-token
    # https://cel.dev/
    #attribute_condition = "attribute.namespace_path==\"psi-software-se\""
    # PSI: Limit to organization and subgroup
    # WARNING: Never use 'attribute.namespace_path.startsWith(\"my-gitlab-org\")'
    #          This also allows other organizations with the same prefix, such as my-gitlab-org-nils.
    attribute_condition = "attribute.namespace_path.startsWith(\"psi-software-se/\")"
    issuer              = "gitlab"
    custom_settings     = null
  }
}

# PSI: Configure CI/CD with GitLab
# Note: Set the branch to null to allow the entire repository to login via WIF provider.
#       Set the branch to "main" to only allow login from the main branch (no other branch).
cicd_repositories = {
  bootstrap = {
    branch            = null
    identity_provider = "git-psi"
    name              = "psi-software-se/terraform/gcp-0-bootstrap"
    type              = "gitlab"
  }
  resman = {
    branch            = null
    identity_provider = "git-psi"
    name              = "psi-software-se/terraform/gcp-1-resman"
    type              = "gitlab"
  }
}

# Slalom: Enable tested and supported features
fast_features = {
  project_factory = true
  sandbox         = true
  teams           = true
}

# Slalom: Create local config. Do not change!
outputs_location = null

project_parent_ids = {
  automation = null
  billing    = null
  # move logging into security folder, after resman stage
  logging    = "folders/67683665164"
}