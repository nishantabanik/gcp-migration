/**
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

resource "google_sourcerepo_repository" "default" {
  project = var.project_id
  name    = var.name
}

# Slalom: Limit region and description
resource "google_cloudbuild_trigger" "default" {
  for_each        = coalesce(var.triggers, {})
  project         = var.project_id
  description     = "Plan: Generates TF execution plan"
  location        = var.location
  name            = each.key
  filename        = each.value.filename
  included_files  = each.value.included_files
  service_account = each.value.service_account
  substitutions   = each.value.substitutions
  trigger_template {
    project_id  = try(each.value.template.project_id, var.project_id)
    branch_name = try(each.value.template.branch_name, null)
    repo_name   = google_sourcerepo_repository.default.name
  }
}

# Slalom: New: Terraform apply trigger
resource "google_cloudbuild_trigger" "terraform-apply" {
  for_each        = coalesce(var.triggers, {})
  project         = var.project_id
  description     = "Apply: Creates or updates according to TF plan"
  location        = var.location
  name            = "${each.key}-apply"
  filename        = each.value.filename
  service_account = each.value.service_account
  trigger_template {
    project_id = try(each.value.template.project_id, var.project_id)
    repo_name  = google_sourcerepo_repository.default.name
    tag_name   = "slalom"
  }
  substitutions = {
    _APPLY_ID = "Insert Apply ID"
  }
  # If this is set on a build, it will become pending when it is run, 
  # and will need to be explicitly approved to start.
  approval_config {
    approval_required = true
  }
}