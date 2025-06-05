run "mandatory_labels_set_verification" {

    command = plan

    assert {
        condition     = contains(try(keys(local.defaults.labels), []), "environment")
        error_message = "Defaults must define the 'environment' label."
    }
    assert {
        condition     = alltrue([for project in local.projects : contains(try(keys(project.labels), []), "owner")])
        error_message = "Each project must define the 'owner' label."
    }
    assert {
        condition     = alltrue([for project in local.projects : contains(try(keys(project.labels), []), "creator")])
        error_message = "Each project must define the 'creator' label."
    }
    assert {
        condition     = alltrue([for project in local.projects : contains(try(keys(project.labels), []), "team")])
        error_message = "Each project must define the 'team' label."
    }
}

run "no_cicd_roles_in_service_accounts" {

    command = plan

    assert {
        condition     = length(local.projects_with_violations) == 0
        error_message = <<-EOT
Found CI/CD roles assigned to service accounts in the following projects:
${local.violation_summary}
EOT
    }
}