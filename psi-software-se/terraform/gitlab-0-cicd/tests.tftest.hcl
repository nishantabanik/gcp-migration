run "unique_id_for_projects" {
    
    command = plan

    assert {
        condition     = alltrue([for key, value in local._projects : (try(value.unique_id, null) != null ? true: false) ])
        error_message = "Each project must define the 'unique_id' in yaml file."
    }

    assert {
        condition     = length([for key, value in local._projects : try(value.unique_id, null)]) == length(toset([for key, value in local._projects : try(value.unique_id, null)]))
        error_message = "'unique_id' in yaml file needs to be unique"
    }
}