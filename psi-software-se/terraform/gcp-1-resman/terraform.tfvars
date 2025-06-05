# Slalom: Allow the Google Cloud Identity customer ID C01g7ajij and domain slalom.com
#         The customer can authorize our Google accounts and we can help them quickly.
organization_policy_configs = {
  # This list constraint defines one or more Cloud Identity or Google Workspace customer IDs whose principals can be added to IAM policies.
  # By default only own Cloud Identity customer ID (organization.customer_id) is allowed.
  # Allow also Cloud Identity customer ID C01g7ajij (slalom.com)
  # Set via organization policy iam.allowedPolicyMemberDomains.
  allowed_policy_member_domains = ["C01g7ajij"]
  # This list constraint defines the set of domains that email addresses added to Essential Contacts can have.
  # By default only own Cloud Identity domain (organization.domain) is allowed.
  # Allow also Cloud Identity domain slalom.com
  # Set via organization policy essentialcontacts.allowedContactDomains.
  # Note: Add domain with at (@) sign!
  allowed_contact_domains = ["@slalom.com"]
}

# PSI: Dev teams
# Groups must already exist. Otherwise Terraform will abort.
# You can use the helper script groups.sh for this.
team_folders = {
  # C2P Teams subfolder
  c2p = {
    descriptive_name = "C2P"
    group_iam = {
      "gcp-organization-admins@psi.de" = [
        "roles/viewer"
      ]
    }
    impersonation_groups = ["gcp-organization-admins@psi.de"]
  }
  # CSF Teams subfolder
  csf = {
    descriptive_name = "CSF"
    group_iam = {
      "gcp-organization-admins@psi.de" = [
        "roles/viewer"
      ]
    }
    impersonation_groups = ["gcp-organization-admins@psi.de"]
  }
  # MES Teams subfolder
  mes = {
    descriptive_name = "MES"
    group_iam = {
      "gcp-organization-admins@psi.de" = [
        "roles/viewer"
      ]
    }
    impersonation_groups = ["gcp-organization-admins@psi.de"]
  }
  # WMS Teams subfolder
  wms = {
    descriptive_name = "WMS"
    group_iam = {
      "gcp-organization-admins@psi.de" = [
        "roles/viewer"
      ]
    }
    impersonation_groups = ["gcp-organization-admins@psi.de"]
  }
}

# PSI: Configure CI/CD with GitLab
cicd_repositories = {
  security = {
    branch            = null
    identity_provider = "git-psi"
    name              = "psi-software-se/terraform/gcp-2-security"
    type              = "gitlab"
  }
  networking = {
    branch            = null
    identity_provider = "git-psi"
    name              = "psi-software-se/terraform/gcp-2-networking"
    type              = "gitlab"
  }
  project_factory_dev = {
    branch            = null
    identity_provider = "git-psi"
    name              = "psi-software-se/terraform/dev/gcp-3-project-factory-dev"
    type              = "gitlab"
  }
  project_factory_prod = {
    branch            = null
    identity_provider = "git-psi"
    name              = "psi-software-se/terraform/prod/gcp-3-project-factory-prod"
    type              = "gitlab"
  }
  project_factory_sbox = {
    branch            = null
    identity_provider = "git-psi"
    name              = "psi-software-se/terraform/gcp-3-project-factory-sbox"
    type              = "gitlab"
  }
  project_factory_legacy = {
    branch            = null
    identity_provider = "git-psi"
    name              = "psi-software-se/terraform/gcp-3-project-factory-legacy"
    type              = "gitlab"
  }
  project_factory_c2p = {
    branch            = null
    identity_provider = "git-psi"
    name              = "psi-software-se/terraform/gcp-3-project-factory-c2p"
    type              = "gitlab"
  }
  # More:
  # data_platform_dev
  # data_platform_prod
  # gke_dev
  # gke_prod
  # Please see: variables.tf
}

# Slalom: Create local config. Do not change!
outputs_location = null
