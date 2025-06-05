locals {
  violations_per_project_raw = {
    for project_name, project_config in local.projects :
    project_name => setintersection(
      toset(try(try(project_config.cicd, {}).sa_roles, [])),
      toset(distinct(concat(
        flatten(values(try(project_config.service_accounts, {}))),
        flatten(values(try(project_config.group_iam, {}))),
        keys(try(project_config.service_accounts_iam, {}))
      )))
    )
  }

  projects_with_violations = {
    for project_name, roles_set in local.violations_per_project_raw :
    project_name => tolist(roles_set)
    if length(roles_set) > 0
  }

  violation_summary = join("\n", [
    for project_name, roles_list in local.projects_with_violations :
    "Project '${project_name}': ${join(", ", roles_list)}"
  ])
}