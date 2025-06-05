locals {
  _files          = fileset(var.data_dir, "**/*.yaml")
  _files_no_group = [for f in local._files : f if !startswith(basename(f), "_group")]

  _path_projects = {
    for f in local._files_no_group :
    trimsuffix(f, ".yaml") => yamldecode(file("${var.data_dir}/${f}"))
  }

  _projects = { for k, v in local._path_projects : v.unique_id => merge(
    v,
    {
      path           = k,
      default_branch = try(v.default_branch, null) != null ? v.default_branch : (try(v.initialize_with_readme, true) == false ? null : "main")
    }
  ) }
  _projects_iac      = { for k, v in local._projects : k => v if startswith(v.path, "terraform/")}
  _projects_test_iac = { for k, v in local._projects : k => v if startswith(v.path, "test-org/") }

  _parents = {
    for k in local._files :
    k => {
      parents = [
        for p in [
          for i in range(length(split("/", k)) - 1, 0) :
          slice(split("/", k), 0, length(split("/", k)) - i)
        ] :
        join("/", p)
      ]
    }
  }

  _unique = toset(flatten([for k, v in local._parents : v.parents]))
  _groups = {
    for g in local._unique :
    g => yamldecode(file("${var.data_dir}/${g}/_group.yaml")) if fileexists("${var.data_dir}/${g}/_group.yaml")
  }

  _level1 = [for k in local._unique : k if length(split("/", k)) == 1]
  _level2 = [for k in local._unique : k if length(split("/", k)) == 2]
  _level3 = [for k in local._unique : k if length(split("/", k)) == 3]
  _level4 = [for k in local._unique : k if length(split("/", k)) == 4]
  _level5 = [for k in local._unique : k if length(split("/", k)) == 5]
  _level6 = [for k in local._unique : k if length(split("/", k)) == 6]
  _level7 = [for k in local._unique : k if length(split("/", k)) == 7]
  _level8 = [for k in local._unique : k if length(split("/", k)) == 8]

  gitlab_groups = merge(
    gitlab_group.level1,
    gitlab_group.level2,
    gitlab_group.level3,
    gitlab_group.level4,
    gitlab_group.level5,
    gitlab_group.level6,
    gitlab_group.level7,
    gitlab_group.level8
  )

  _gitlab_organization_groups = { for k, v in local._groups : k => v if try(v.saml_link, null) != null }
  gitlab_organization_groups = merge([
    for group, data in local._gitlab_organization_groups : {
      for saml_group_name, access_level in data.saml_link : "${group}-${saml_group_name}" => { group_name = group, saml_group_name = saml_group_name, access_level = access_level }
  }]...)

  _gitlab_group_share_groups = { for k, v in local._groups : k => v if try(v.access_groups, null) != null }
  gitlab_group_share_groups = merge([
    for group, data in local._gitlab_group_share_groups : {
      for access_group, access_level in data.access_groups : "${group}-${access_group}" => { group_name = group, access_group = access_group, access_level = access_level }
  }]...)

  _gitlab_group_share_projects = { for k, v in local._projects : k => v if try(v.access_groups, null) != null }
  gitlab_group_share_projects = merge([
    for project, data in local._gitlab_group_share_projects : {
      for access_group, access_level in data.access_groups : "${project}-${access_group}" => { project_uid = project, access_group = access_group, access_level = access_level }
  }]...)

  _gitlab_project_access_tokens = { for k, v in local._projects : k => v if try(v.access_tokens, null) != null }
  gitlab_project_access_tokens = merge([
    for project, data in local._gitlab_project_access_tokens : {
      for access_token in data.access_tokens : "${project}-${access_token.name}" => {
        project_uid   = project,
        name          = access_token.name,
        variable_name = try(access_token.variable_name, access_token.name)
        scopes        = access_token.scopes,
        description   = format("%s (TF managed)", try(access_token.description, "")),
        access_level  = try(access_token.access_level, "guest"),
        protected     = try(access_token.protected, true)
      }
  }]...)

  _gitlab_protected_branches = { for k, v in local._projects : k => v if try(v.protected_branches, null) != null }
  gitlab_protected_branches = merge([
    for project, data in local._gitlab_protected_branches : {
      for protected_branch in data.protected_branches : "${project}-${protected_branch.name}" => {
        project_uid                  = project,
        name                         = protected_branch.name,
        push_access_level            = try(protected_branch.push_access_level, "maintainer")
        merge_access_level           = try(protected_branch.merge_access_level, "developer")
        allow_force_push             = try(protected_branch.allow_force_push, false)
        code_owner_approval_required = try(protected_branch.code_owner_approval_required, false)
        groups_allowed_to_push       = try(protected_branch.groups_allowed_to_push, [])
        groups_allowed_to_merge      = try(protected_branch.groups_allowed_to_merge, [])
      }
  }]...)

}

output "gitlab_project_access_tokens" {
  value     = local.gitlab_project_access_tokens
  sensitive = false
}

output "gitlab_group_share_projects" {
  value     = local.gitlab_group_share_projects
  sensitive = false
}

output "gitlab_group_share_groups" {
  value     = local.gitlab_group_share_groups
  sensitive = false
}

output "gitlab_organization_groups" {
  value     = local.gitlab_organization_groups
  sensitive = false
}

output "groups" {
  value     = keys(local.gitlab_groups)
  sensitive = false
}

output "projects" {
  value     = keys(local._projects)
  sensitive = false
}
