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