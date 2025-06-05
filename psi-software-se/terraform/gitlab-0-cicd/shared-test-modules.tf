resource "tls_private_key" "test_modules" {
  algorithm = "ED25519"
}

resource "gitlab_project" "shared_test_modules" {
  count                           = 1
  name                            = "modules"
  description                     = "FAST Shared modules for test organization (TF managed)"
  namespace_id                    = local.gitlab_groups["test-org"].id
  restrict_user_defined_variables = true
  default_branch                  = "stable"
}

resource "gitlab_deploy_key" "test_modules" {
  count   = 1
  project = gitlab_project.shared_test_modules.0.id
  title   = "Modules repository access (TF managed)"
  key     = tls_private_key.test_modules.public_key_openssh
}

resource "gitlab_branch_protection" "test_modules_branch_protection" {
  project                      = gitlab_project.shared_test_modules.0.id
  branch                       = "stable"
  push_access_level            = "developer"
  merge_access_level           = "maintainer"
  allow_force_push             = false
  code_owner_approval_required = false
}
