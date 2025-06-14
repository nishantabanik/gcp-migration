/**
 * Copyright 2025 Slalom GmbH
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# tfdoc:file:description CI/CD resources for the project factory branch.

# source repositories

# TODO: Delete

moved {
  from = module.branch-teams-dev-pf-cicd-repo
  to   = module.branch-pf-dev-cicd-repo
}

module "branch-pf-dev-cicd-repo" {
  source = "git@gitlab.com:psi-software-se/terraform/modules.git//source-repository?ref=stable"
  for_each = (
    try(local.cicd_repositories.project_factory_dev.type, null) == "sourcerepo"
    ? { 0 = local.cicd_repositories.project_factory_dev }
    : {}
  )
  project_id = var.automation.project_id
  name       = each.value.name
  iam = {
    "roles/source.admin"  = [module.branch-pf-dev-sa[0].iam_email]
    "roles/source.reader" = [module.branch-pf-dev-sa-cicd[0].iam_email]
  }
  # Slalom: Limit region
  location = var.locations.trigger
  triggers = {
    fast-03-pf-dev = {
      filename = ".cloudbuild/workflow.yaml"
      # Slalom: Include also TFVARS and YAML files from factories
      included_files = [
        "**/*json", "**/*tf", "**/*tfvars", "**/*yaml", ".cloudbuild/workflow.yaml"
      ]
      service_account = module.branch-pf-dev-sa-cicd[0].id
      substitutions   = {}
      template = {
        project_id  = null
        branch_name = each.value.branch
        repo_name   = each.value.name
        tag_name    = null
      }
    }
  }
  depends_on = [module.branch-pf-dev-sa-cicd]
}

moved {
  from = module.branch-teams-prod-pf-cicd-repo
  to   = module.branch-pf-prod-cicd-repo
}

module "branch-pf-prod-cicd-repo" {
  source = "git@gitlab.com:psi-software-se/terraform/modules.git//source-repository?ref=stable"
  for_each = (
    try(local.cicd_repositories.project_factory_prod.type, null) == "sourcerepo"
    ? { 0 = local.cicd_repositories.project_factory_prod }
    : {}
  )
  project_id = var.automation.project_id
  name       = each.value.name
  iam = {
    "roles/source.admin"  = [module.branch-pf-prod-sa[0].iam_email]
    "roles/source.reader" = [module.branch-pf-prod-sa-cicd[0].iam_email]
  }
  # Slalom: Limit region
  location = var.locations.trigger
  triggers = {
    fast-03-pf-prod = {
      filename = ".cloudbuild/workflow.yaml"
      included_files = [
        "**/*json", "**/*tf", "**/*yaml", ".cloudbuild/workflow.yaml"
      ]
      service_account = module.branch-pf-prod-sa-cicd[0].id
      substitutions   = {}
      template = {
        project_id  = null
        branch_name = each.value.branch
        repo_name   = each.value.name
        tag_name    = null
      }
    }
  }
  depends_on = [module.branch-pf-prod-sa-cicd]
}

# SAs used by CI/CD workflows to impersonate automation SAs

moved {
  from = module.branch-teams-dev-pf-sa-cicd
  to   = module.branch-pf-dev-sa-cicd
}

module "branch-pf-dev-sa-cicd" {
  source = "git@gitlab.com:psi-software-se/terraform/modules.git//iam-service-account?ref=stable"
  for_each = (
    try(local.cicd_repositories.project_factory_dev.name, null) != null
    ? { 0 = local.cicd_repositories.project_factory_dev }
    : {}
  )
  project_id   = var.automation.project_id
  name         = "dev-pf-resman-pf-1"
  display_name = "Terraform CI/CD project factory development service account."
  prefix       = var.prefix
  iam = (
    each.value.type == "sourcerepo"
    # used directly from the cloud build trigger for source repos
    ? {
      "roles/iam.serviceAccountUser" = local.automation_resman_sa_iam
    }
    # impersonated via workload identity federation for external repos
    : {
      "roles/iam.workloadIdentityUser" = [
        each.value.branch == null
        ? format(
          local.identity_providers[each.value.identity_provider].principalset_tpl,
          var.automation.federated_identity_pool,
          each.value.name
        )
        : format(
          local.identity_providers[each.value.identity_provider].principal_tpl,
          var.automation.federated_identity_pool,
          each.value.name,
          each.value.branch
        )
      ]
    }
  )
  iam_project_roles = {
    (var.automation.project_id) = ["roles/logging.logWriter"]
  }
  iam_storage_roles = {
    (var.automation.outputs_bucket) = ["roles/storage.objectViewer"]
    # Slalom: Bucket for build logs
    (var.automation.build_log_bucket) = ["roles/storage.admin"]
  }
}

moved {
  from = module.branch-teams-prod-pf-sa-cicd
  to   = module.branch-pf-prod-sa-cicd
}

module "branch-pf-prod-sa-cicd" {
  source = "git@gitlab.com:psi-software-se/terraform/modules.git//iam-service-account?ref=stable"
  for_each = (
    try(local.cicd_repositories.project_factory_prod.name, null) != null
    ? { 0 = local.cicd_repositories.project_factory_prod }
    : {}
  )
  project_id   = var.automation.project_id
  name         = "prod-pf-resman-pf-1"
  display_name = "Terraform CI/CD project factory production service account."
  prefix       = var.prefix
  iam = (
    each.value.type == "sourcerepo"
    # used directly from the cloud build trigger for source repos
    ? {
      "roles/iam.serviceAccountUser" = local.automation_resman_sa_iam
    }
    # impersonated via workload identity federation for external repos
    : {
      "roles/iam.workloadIdentityUser" = [
        each.value.branch == null
        ? format(
          local.identity_providers[each.value.identity_provider].principalset_tpl,
          var.automation.federated_identity_pool,
          each.value.name
        )
        : format(
          local.identity_providers[each.value.identity_provider].principal_tpl,
          var.automation.federated_identity_pool,
          each.value.name,
          each.value.branch
        )
      ]
    }
  )
  iam_project_roles = {
    (var.automation.project_id) = ["roles/logging.logWriter"]
  }
  iam_storage_roles = {
    (var.automation.outputs_bucket) = ["roles/storage.objectViewer"]
    # Slalom: Bucket for build logs
    (var.automation.build_log_bucket) = ["roles/storage.admin"]
  }
}

module "branch-pf-sbox-sa-cicd" {
  source = "git@gitlab.com:psi-software-se/terraform/modules.git//iam-service-account?ref=stable"
  for_each = (
    try(local.cicd_repositories.project_factory_sbox.name, null) != null
    ? { 0 = local.cicd_repositories.project_factory_sbox }
    : {}
  )
  project_id   = var.automation.project_id
  name         = "sbox-pf-resman-pf-1"
  display_name = "Terraform CI/CD project factory sandbox service account."
  prefix       = var.prefix
  iam = (
    each.value.type == "sourcerepo"
    # used directly from the cloud build trigger for source repos
    ? {
      "roles/iam.serviceAccountUser" = local.automation_resman_sa_iam
    }
    # impersonated via workload identity federation for external repos
    : {
      "roles/iam.workloadIdentityUser" = [
        each.value.branch == null
        ? format(
          local.identity_providers[each.value.identity_provider].principalset_tpl,
          var.automation.federated_identity_pool,
          each.value.name
        )
        : format(
          local.identity_providers[each.value.identity_provider].principal_tpl,
          var.automation.federated_identity_pool,
          each.value.name,
          each.value.branch
        )
      ]
    }
  )
  iam_project_roles = {
    (var.automation.project_id) = ["roles/logging.logWriter"]
  }
  iam_storage_roles = {
    (var.automation.outputs_bucket) = ["roles/storage.objectViewer"]
    # Slalom: Bucket for build logs
    (var.automation.build_log_bucket) = ["roles/storage.admin"]
  }
}

module "branch-pf-legacy-sa-cicd" {
  source = "git@gitlab.com:psi-software-se/terraform/modules.git//iam-service-account?ref=stable"
  for_each = (
    try(local.cicd_repositories.project_factory_legacy.name, null) != null
    ? { 0 = local.cicd_repositories.project_factory_legacy }
    : {}
  )
  project_id   = var.automation.project_id
  name         = "legacy-pf-resman-pf-1"
  display_name = "Terraform CI/CD project factory legacy service account."
  prefix       = var.prefix
  iam = (
    each.value.type == "sourcerepo"
    # used directly from the cloud build trigger for source repos
    ? {
      "roles/iam.serviceAccountUser" = local.automation_resman_sa_iam
    }
    # impersonated via workload identity federation for external repos
    : {
      "roles/iam.workloadIdentityUser" = [
        each.value.branch == null
        ? format(
          local.identity_providers[each.value.identity_provider].principalset_tpl,
          var.automation.federated_identity_pool,
          each.value.name
        )
        : format(
          local.identity_providers[each.value.identity_provider].principal_tpl,
          var.automation.federated_identity_pool,
          each.value.name,
          each.value.branch
        )
      ]
    }
  )
  iam_project_roles = {
    (var.automation.project_id) = ["roles/logging.logWriter"]
  }
  iam_storage_roles = {
    (var.automation.outputs_bucket) = ["roles/storage.objectViewer"]
    # Slalom: Bucket for build logs
    (var.automation.build_log_bucket) = ["roles/storage.admin"]
  }
}

module "branch-pf-c2p-sa-cicd" {
  source = "git@gitlab.com:psi-software-se/terraform/modules.git//iam-service-account?ref=stable"
  for_each = (
    try(local.cicd_repositories.project_factory_c2p.name, null) != null
    ? { 0 = local.cicd_repositories.project_factory_c2p }
    : {}
  )
  project_id   = var.automation.project_id
  name         = "c2p-pf-resman-pf-1"
  display_name = "Terraform CI/CD project factory c2p service account."
  prefix       = var.prefix
  iam = (
    each.value.type == "sourcerepo"
    # used directly from the cloud build trigger for source repos
    ? {
      "roles/iam.serviceAccountUser" = local.automation_resman_sa_iam
    }
    # impersonated via workload identity federation for external repos
    : {
      "roles/iam.workloadIdentityUser" = [
        each.value.branch == null
        ? format(
          local.identity_providers[each.value.identity_provider].principalset_tpl,
          var.automation.federated_identity_pool,
          each.value.name
        )
        : format(
          local.identity_providers[each.value.identity_provider].principal_tpl,
          var.automation.federated_identity_pool,
          each.value.name,
          each.value.branch
        )
      ]
    }
  )
  iam_project_roles = {
    (var.automation.project_id) = ["roles/logging.logWriter"]
  }
  iam_storage_roles = {
    (var.automation.outputs_bucket) = ["roles/storage.objectViewer"]
    # Slalom: Bucket for build logs
    (var.automation.build_log_bucket) = ["roles/storage.admin"]
  }
}

