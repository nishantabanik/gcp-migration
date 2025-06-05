
# Slalom: Configures the locations and rotation period,
#         used for keys that don't specifically configure them.
kms_defaults = {
  # Slalom: Limit regions
  # europe-west3: Frankfurt (https://gcloud-compute.com/europe-west3.html)
  # europe-west4: Netherlands (https://gcloud-compute.com/europe-west4.html)
  locations = ["europe-west3", "europe-west4"]
  # Slalom: 90 days
  rotation_period = "7776000s"
}

# Slalom: Configures the actual keys to create,
#         and also allows configuring their IAM bindings and labels,
#         and overriding locations and rotation period.
kms_keys = {
  # Slalom: Map key (like 'compute') is the KMS key name.
  compute = {
    iam             = null
    labels          = { service = "compute" }
    locations       = null
    rotation_period = null
  }
  storage = {
    iam             = null
    labels          = { service = "storage" }
    locations       = null
    rotation_period = null
  }
}

# Slalom: Add here the VPC Service Controls configuration
#         Please see 2-security/README.md

# Slalom: Create local config. Do not change!
outputs_location = null