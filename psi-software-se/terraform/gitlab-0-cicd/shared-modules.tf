resource "tls_private_key" "modules" {
  algorithm = "ED25519"
}

resource "gitlab_project" "shared_modules" {
  count                           = 1
  name                            = "modules"
  description                     = "FAST Shared modules (TF managed)"
  namespace_id                    = local.gitlab_groups["terraform"].id
  restrict_user_defined_variables = true
  default_branch                  = "stable"
}

resource "gitlab_deploy_key" "modules" {
  count   = 1
  project = gitlab_project.shared_modules.0.id
  title   = "Modules repository access (TF managed)"
  key     = tls_private_key.modules.public_key_openssh
}

resource "gitlab_branch_protection" "modules_branch_protection" {
  project                      = gitlab_project.shared_modules.0.id
  branch                       = "stable"
  push_access_level            = "no one"
  merge_access_level           = "maintainer"
  allow_force_push             = false
  code_owner_approval_required = false
}
