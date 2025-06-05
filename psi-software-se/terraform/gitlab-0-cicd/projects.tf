resource "gitlab_project" "structure" {
  for_each                                         = local._projects
  name                                             = (try(each.value.name, null) != null ? each.value.name : split("/", each.value.path)[length(split("/", each.value.path)) - 1])
  namespace_id                                     = local.gitlab_groups[join("/", slice(split("/", each.value.path), 0, length(split("/", each.value.path)) - 1))].id
  description                                      = format("%s (TF managed)", try(each.value.description, null) != null ? each.value.description : "Project ${each.key}.")
  path                                             = split("/", each.value.path)[length(split("/", each.value.path)) - 1]
  visibility_level                                 = try(each.value.visibility_level, "private")
  merge_requests_enabled                           = try(each.value.merge_requests_enabled, true)
  issues_enabled                                   = try(each.value.issues_enabled, false)
  wiki_enabled                                     = try(each.value.wiki_enabled, false)
  restrict_user_defined_variables                  = try(each.value.restrict_user_defined_variables, false)
  ci_separated_caches                              = try(each.value.ci_separated_caches, true)
  merge_pipelines_enabled                          = try(each.value.merge_pipelines_enabled, false)
  merge_trains_enabled                             = try(each.value.merge_trains_enabled, false)
  squash_option                                    = try(each.value.squash_option, "default_on")
  only_allow_merge_if_pipeline_succeeds            = try(each.value.only_allow_merge_if_pipeline_succeeds, true)
  auto_devops_enabled                              = try(each.value.auto_devops_enabled, false)
  ci_pipeline_variables_minimum_override_role      = try(each.value.ci_pipeline_variables_minimum_override_role, "developer")
  ci_restrict_pipeline_cancellation_role           = try(each.value.ci_restrict_pipeline_cancellation_role, "developer")
  default_branch                                   = each.value.default_branch
  merge_method                                     = try(each.value.merge_method, "ff")
  only_allow_merge_if_all_discussions_are_resolved = try(each.value.only_allow_merge_if_all_discussions_are_resolved, true)
  pre_receive_secret_detection_enabled             = try(each.value.pre_receive_secret_detection_enabled, true)
  prevent_merge_without_jira_issue                 = try(each.value.prevent_merge_without_jira_issue, false)
  printing_merge_request_link_enabled              = try(each.value.printing_merge_request_link_enabled, true)
  remove_source_branch_after_merge                 = try(each.value.remove_source_branch_after_merge, true)
  shared_runners_enabled                           = try(each.value.shared_runners_enabled, true)
  squash_commit_template                           = try(each.value.squash_commit_template, "")
  initialize_with_readme                           = try(each.value.initialize_with_readme, true)
  push_rules {
    author_email_regex          = try(each.value.author_email_regex, "")
    branch_name_regex           = try(each.value.branch_name_regex, "")
    commit_committer_check      = try(each.value.commit_committer_check, false)
    commit_committer_name_check = try(each.value.commit_committer_name_check, false)
    commit_message_regex        = try(each.value.commit_message_regex, "")
    # Using Secure -> Security configuration -> Secret push protection -> Enabled instead
    prevent_secrets = try(each.value.prevent_secrets, false)
  }
}

resource "gitlab_project_approval_rule" "projects" {
  for_each                          = local._projects
  project                           = gitlab_project.structure[each.key].id
  name                              = "All Members"
  applies_to_all_protected_branches = false
  approvals_required                = try(each.value.approvals_required, 1)
  rule_type                         = "any_approver"
}

resource "gitlab_project_level_mr_approvals" "rules" {
  for_each                                       = local._projects
  project                                        = gitlab_project.structure[each.key].id
  disable_overriding_approvers_per_merge_request = try(each.value.disable_overriding_approvers_per_merge_request, true)
  merge_requests_author_approval                 = try(each.value.merge_requests_author_approval, false)
  merge_requests_disable_committers_approval     = try(each.value.merge_requests_disable_committers_approval, true)
  reset_approvals_on_push                        = try(each.value.reset_approvals_on_push, true)
}

resource "gitlab_branch_protection" "branch_protection" {
  for_each                     = local.gitlab_protected_branches
  project                      = gitlab_project.structure[each.value.project_uid].id
  branch                       = each.value.name
  push_access_level            = each.value.push_access_level
  merge_access_level           = each.value.merge_access_level
  allow_force_push             = each.value.allow_force_push
  code_owner_approval_required = each.value.code_owner_approval_required
  depends_on                   = [gitlab_project.structure]

  dynamic "allowed_to_push" {
    for_each = each.value.groups_allowed_to_push
    content {
      group_id = local.gitlab_groups[allowed_to_push.value].id
    }
  }

  dynamic "allowed_to_merge" {
    for_each = each.value.groups_allowed_to_merge
    content {
      group_id = local.gitlab_groups[allowed_to_merge.value].id
    }
  }
}

resource "gitlab_project_variable" "cicd_modules" {
  for_each  = local._projects_iac
  project   = gitlab_project.structure[each.key].id
  key       = "CICD_MODULES_KEY"
  value     = tls_private_key.modules.private_key_openssh
  protected = false
}

resource "gitlab_project_variable" "cicd_test_modules" {
  for_each  = local._projects_test_iac
  project   = gitlab_project.structure[each.key].id
  key       = "CICD_MODULES_KEY"
  value     = tls_private_key.test_modules.private_key_openssh
  protected = false
}

resource "gitlab_project_share_group" "organization_share_group" {
  for_each     = local.gitlab_group_share_projects
  project      = gitlab_project.structure[each.value.project_uid].id
  group_id     = local.gitlab_groups[each.value.access_group].id
  group_access = try(each.value.access_level, "guest")
}

resource "gitlab_project_access_token" "project_access_token" {
  for_each     = local.gitlab_project_access_tokens
  project      = gitlab_project.structure[each.value.project_uid].id
  name         = each.value.name
  scopes       = each.value.scopes
  access_level = each.value.access_level
  description  = each.value.description
  rotation_configuration = {
    expiration_days    = 365
    rotate_before_days = 30
  }
}

resource "gitlab_project_variable" "project_access_token_variable" {
  for_each    = local.gitlab_project_access_tokens
  project     = gitlab_project.structure[each.value.project_uid].id
  key         = each.value.variable_name
  value       = gitlab_project_access_token.project_access_token[each.key].token
  description = each.value.description
  hidden      = true
  masked      = true
  protected   = each.value.protected
  depends_on  = [gitlab_project_access_token.project_access_token]
}

output "ssh_url_to_repo" {
  value = { for k, v in gitlab_project.structure : k => v.ssh_url_to_repo }
}
