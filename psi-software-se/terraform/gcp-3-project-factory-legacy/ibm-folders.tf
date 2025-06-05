# tfdoc:file:description Legacy subfolder configuration.

module "legacy_ibm" {
  source        = "git@gitlab.com:psi-software-se/terraform/modules.git//folder?ref=stable"
  parent        = "organizations/${var.organization.id}"
  name          = "Legacy"
  folder_create = false # Folder is created in Resman stage
  id            = var.folder_ids.legacy # Output from Resman stage
}

locals {
  teams = {
    "gem" : {
      "non-prod-int" : {}
      "non-prod-ext" : {}
      "prod-int" : {}
      "prod-ext" : {}
    }
    "cf-tech" : {
      "non-prod-int" : {}
      "non-prod-ext" : {}
      "prod-int" : {}
      "prod-ext" : {}
    }
    "cf-fin" : {
      "prod-int" : {}
    }
    "cf-iai" : {
      "non-prod-int" : {}
      "non-prod-ext" : {}
      "prod-int" : {}
      "prod-ext" : {}
    }
    "cf-its" : {
      "non-prod-int" : {}
      "non-prod-ext" : {}
      "prod-int" : {}
      "prod-ext" : {}
    }
  }

  level1 = keys(local.teams)

  level2 = flatten([
    for team_name, environments in local.teams : [
      for env_name, _ in environments : "${team_name}/${env_name}"
    ]
  ])

  level3 = flatten([
    for team_name, environments in local.teams : [
      for env_name, sublevels in environments : [
        for sub_name, _ in sublevels : "${team_name}/${env_name}/${sub_name}"
      ] if can(keys(sublevels)) # Check if sublevels is a map before iterating
    ]
  ])

  level4 = flatten([
    for team_name, environments in local.teams : [
      for env_name, sublevels in environments : [
        for sub_name, sub_sublevels in sublevels : [
          for sub_sub_name, _ in sub_sublevels : "${team_name}/${env_name}/${sub_name}/${sub_sub_name}"
        ] if can(keys(sub_sublevels))
      ] if can(keys(sublevels)) # Check if sublevels is a map before iterating
    ]
  ])

  level5 = flatten([
    for team_name, environments in local.teams : [
      for env_name, sublevels in environments : [
        for sub_name, sub_sublevels in sublevels : [
          for sub_sub_name, sub_sub_sublevels in sub_sublevels : [
            for sub_sub_sub_name, _ in sub_sub_sublevels :
            "${team_name}/${env_name}/${sub_name}/${sub_sub_name}/${sub_sub_sub_name}"
          ] if can(keys(sub_sub_sublevels))
        ] if can(keys(sub_sublevels))
      ] if can(keys(sublevels)) # Check if sublevels is a map before iterating
    ]
  ])

  folders = merge({for k in local.level1 : k => module.folders_level1[k]},
    {for k in local.level2 : k => module.folders_level2[k]},
    {for k in local.level3 : k => module.folders_level3[k]},
    {for k in local.level4 : k => module.folders_level4[k]},
    {for k in local.level5 : k => module.folders_level5[k]}
  )
}

output "folder_ids" {
  description = "Folder ids"
  value = {for k, v in local.folders : k => local.folders[k].id}
}

module "folders_level1" {
  source   = "git@gitlab.com:psi-software-se/terraform/modules.git//folder?ref=stable"
  parent   = module.legacy_ibm.id
  for_each = {for k in local.level1 : k => k}
  name     = "Team ${each.value}"
  group_iam = {}
}

module "folders_level2" {
  source   = "git@gitlab.com:psi-software-se/terraform/modules.git//folder?ref=stable"
  for_each = {for k in local.level2 : k => k}
  parent   = module.folders_level1[join("/", slice(split("/", each.key), 0, length(split("/", each.key)) - 1))].id
  name     = split("/", each.key)[length(split("/", each.key)) - 1]
  group_iam = {}
}

module "folders_level3" {
  source   = "git@gitlab.com:psi-software-se/terraform/modules.git//folder?ref=stable"
  for_each = {for k in local.level3 : k => k}
  parent   = module.folders_level2[join("/", slice(split("/", each.key), 0, length(split("/", each.key)) - 1))].id
  name     = split("/", each.key)[length(split("/", each.key)) - 1]
  group_iam = {}
}

module "folders_level4" {
  source   = "git@gitlab.com:psi-software-se/terraform/modules.git//folder?ref=stable"
  for_each = {for k in local.level4 : k => k}
  parent   = module.folders_level3[join("/", slice(split("/", each.key), 0, length(split("/", each.key)) - 1))].id
  name     = split("/", each.key)[length(split("/", each.key)) - 1]
  group_iam = {}
}

module "folders_level5" {
  source   = "git@gitlab.com:psi-software-se/terraform/modules.git//folder?ref=stable"
  for_each = {for k in local.level5 : k => k}
  parent   = module.folders_level4[join("/", slice(split("/", each.key), 0, length(split("/", each.key)) - 1))].id
  name     = split("/", each.key)[length(split("/", each.key)) - 1]
  group_iam = {}
}
