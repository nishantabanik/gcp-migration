variable "start_parent_id" {
  description = "Parent ID for first folder level"
  default     = 92397476
}

resource "gitlab_group" "level1" {
  for_each               = toset(local._level1)
  name                   = try(local._groups[each.key].name, split("/", each.key)[length(split("/", each.key)) - 1])
  path                   = split("/", each.key)[length(split("/", each.key)) - 1]
  description            = format("%s (TF managed)", try(local._groups[each.key].description, "Description for ${each.key}"))
  parent_id              = var.start_parent_id
  project_creation_level = "maintainer"
  share_with_group_lock  = try(local._groups[each.key].share_with_group_lock, false)
  default_branch_protection_defaults {
    allowed_to_push            = try(local._groups[each.key].allowed_to_push, ["maintainer"])
    allow_force_push           = try(local._groups[each.key].allow_force_push, false)
    allowed_to_merge           = try(local._groups[each.key].allowed_to_merge, ["developer", "maintainer"])
    developer_can_initial_push = try(local._groups[each.key].developer_can_initial_push, true)
  }
}

resource "gitlab_group" "level2" {
  for_each               = toset(local._level2)
  name                   = try(local._groups[each.key].name, split("/", each.key)[length(split("/", each.key)) - 1])
  path                   = split("/", each.key)[length(split("/", each.key)) - 1]
  description            = format("%s (TF managed)", try(local._groups[each.key].description, "Description for ${each.key}"))
  parent_id              = gitlab_group.level1[join("/", slice(split("/", each.key), 0, length(split("/", each.key)) - 1))].id
  project_creation_level = "maintainer"
  share_with_group_lock  = try(local._groups[each.key].share_with_group_lock, false)
  default_branch_protection_defaults {
    allowed_to_push            = try(local._groups[each.key].allowed_to_push, ["maintainer"])
    allow_force_push           = try(local._groups[each.key].allow_force_push, false)
    allowed_to_merge           = try(local._groups[each.key].allowed_to_merge, ["developer", "maintainer"])
    developer_can_initial_push = try(local._groups[each.key].developer_can_initial_push, true)
  }
}

resource "gitlab_group" "level3" {
  for_each               = toset(local._level3)
  name                   = try(local._groups[each.key].name, split("/", each.key)[length(split("/", each.key)) - 1])
  path                   = split("/", each.key)[length(split("/", each.key)) - 1]
  description            = format("%s (TF managed)", try(local._groups[each.key].description, "Description for ${each.key}"))
  parent_id              = gitlab_group.level2[join("/", slice(split("/", each.key), 0, length(split("/", each.key)) - 1))].id
  project_creation_level = "maintainer"
  share_with_group_lock  = try(local._groups[each.key].share_with_group_lock, false)
  default_branch_protection_defaults {
    allowed_to_push            = try(local._groups[each.key].allowed_to_push, ["maintainer"])
    allow_force_push           = try(local._groups[each.key].allow_force_push, false)
    allowed_to_merge           = try(local._groups[each.key].allowed_to_merge, ["developer", "maintainer"])
    developer_can_initial_push = try(local._groups[each.key].developer_can_initial_push, true)
  }
}

resource "gitlab_group" "level4" {
  for_each               = toset(local._level4)
  name                   = try(local._groups[each.key].name, split("/", each.key)[length(split("/", each.key)) - 1])
  path                   = split("/", each.key)[length(split("/", each.key)) - 1]
  description            = format("%s (TF managed)", try(local._groups[each.key].description, "Description for ${each.key}"))
  parent_id              = gitlab_group.level3[join("/", slice(split("/", each.key), 0, length(split("/", each.key)) - 1))].id
  project_creation_level = "maintainer"
  share_with_group_lock  = try(local._groups[each.key].share_with_group_lock, false)
  default_branch_protection_defaults {
    allowed_to_push            = try(local._groups[each.key].allowed_to_push, ["maintainer"])
    allow_force_push           = try(local._groups[each.key].allow_force_push, false)
    allowed_to_merge           = try(local._groups[each.key].allowed_to_merge, ["developer", "maintainer"])
    developer_can_initial_push = try(local._groups[each.key].developer_can_initial_push, true)
  }
}

resource "gitlab_group" "level5" {
  for_each               = toset(local._level5)
  name                   = try(local._groups[each.key].name, split("/", each.key)[length(split("/", each.key)) - 1])
  path                   = split("/", each.key)[length(split("/", each.key)) - 1]
  description            = format("%s (TF managed)", try(local._groups[each.key].description, "Description for ${each.key}"))
  parent_id              = gitlab_group.level4[join("/", slice(split("/", each.key), 0, length(split("/", each.key)) - 1))].id
  project_creation_level = "maintainer"
  share_with_group_lock  = try(local._groups[each.key].share_with_group_lock, false)
  default_branch_protection_defaults {
    allowed_to_push            = try(local._groups[each.key].allowed_to_push, ["maintainer"])
    allow_force_push           = try(local._groups[each.key].allow_force_push, false)
    allowed_to_merge           = try(local._groups[each.key].allowed_to_merge, ["developer", "maintainer"])
    developer_can_initial_push = try(local._groups[each.key].developer_can_initial_push, true)
  }
}

resource "gitlab_group" "level6" {
  for_each               = toset(local._level6)
  name                   = try(local._groups[each.key].name, split("/", each.key)[length(split("/", each.key)) - 1])
  path                   = split("/", each.key)[length(split("/", each.key)) - 1]
  description            = format("%s (TF managed)", try(local._groups[each.key].description, "Description for ${each.key}"))
  parent_id              = gitlab_group.level5[join("/", slice(split("/", each.key), 0, length(split("/", each.key)) - 1))].id
  project_creation_level = "maintainer"
  share_with_group_lock  = try(local._groups[each.key].share_with_group_lock, false)
  default_branch_protection_defaults {
    allowed_to_push            = try(local._groups[each.key].allowed_to_push, ["maintainer"])
    allow_force_push           = try(local._groups[each.key].allow_force_push, false)
    allowed_to_merge           = try(local._groups[each.key].allowed_to_merge, ["developer", "maintainer"])
    developer_can_initial_push = try(local._groups[each.key].developer_can_initial_push, true)
  }
}

resource "gitlab_group" "level7" {
  for_each               = toset(local._level7)
  name                   = try(local._groups[each.key].name, split("/", each.key)[length(split("/", each.key)) - 1])
  path                   = split("/", each.key)[length(split("/", each.key)) - 1]
  description            = format("%s (TF managed)", try(local._groups[each.key].description, "Description for ${each.key}"))
  parent_id              = gitlab_group.level6[join("/", slice(split("/", each.key), 0, length(split("/", each.key)) - 1))].id
  project_creation_level = "maintainer"
  share_with_group_lock  = try(local._groups[each.key].share_with_group_lock, false)
  default_branch_protection_defaults {
    allowed_to_push            = try(local._groups[each.key].allowed_to_push, ["maintainer"])
    allow_force_push           = try(local._groups[each.key].allow_force_push, false)
    allowed_to_merge           = try(local._groups[each.key].allowed_to_merge, ["developer", "maintainer"])
    developer_can_initial_push = try(local._groups[each.key].developer_can_initial_push, true)
  }
}

resource "gitlab_group" "level8" {
  for_each               = toset(local._level8)
  name                   = try(local._groups[each.key].name, split("/", each.key)[length(split("/", each.key)) - 1])
  path                   = split("/", each.key)[length(split("/", each.key)) - 1]
  description            = format("%s (TF managed)", try(local._groups[each.key].description, "Description for ${each.key}"))
  parent_id              = gitlab_group.level7[join("/", slice(split("/", each.key), 0, length(split("/", each.key)) - 1))].id
  project_creation_level = "maintainer"
  share_with_group_lock  = try(local._groups[each.key].share_with_group_lock, false)
  default_branch_protection_defaults {
    allowed_to_push            = try(local._groups[each.key].allowed_to_push, ["maintainer"])
    allow_force_push           = try(local._groups[each.key].allow_force_push, false)
    allowed_to_merge           = try(local._groups[each.key].allowed_to_merge, ["developer", "maintainer"])
    developer_can_initial_push = try(local._groups[each.key].developer_can_initial_push, true)
  }
}

resource "gitlab_group_saml_link" "group_saml_link" {
  for_each        = local.gitlab_organization_groups
  group           = local.gitlab_groups[each.value.group_name].id
  access_level    = try(each.value.access_level, "guest")
  saml_group_name = try(each.value.saml_group_name, "")
}
resource "gitlab_group_share_group" "organization_share_group" {
  for_each       = local.gitlab_group_share_groups
  group_id       = local.gitlab_groups[each.value.group_name].id
  share_group_id = local.gitlab_groups[each.value.access_group].id
  group_access   = try(each.value.access_level, "guest")
}

resource "gitlab_group_share_group" "top_level_organization_share_group_app_gitlab_cft" {
  group_id       = var.start_parent_id
  share_group_id = local.gitlab_groups["organization/app-gitlab-cft"].id
  group_access   = "reporter"
}
resource "gitlab_group_share_group" "top_level_organization_share_group_app_gitlab_security" {
  group_id       = var.start_parent_id
  share_group_id = local.gitlab_groups["organization/app-gitlab-security"].id
  group_access   = "reporter"
}
resource "gitlab_group_share_group" "top_level_organization_share_group_app_gitlab_its" {
  group_id       = var.start_parent_id
  share_group_id = local.gitlab_groups["organization/app-gitlab-its"].id
  group_access   = "reporter"
}
