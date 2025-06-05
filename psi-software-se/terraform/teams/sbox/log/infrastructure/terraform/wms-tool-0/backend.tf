terraform {
  backend "http" {
    address        = "https://gitlab.com/api/v4/projects/61363786/terraform/state/poc_tool"
    lock_address   = "https://gitlab.com/api/v4/projects/61363786/terraform/state/poc_tool/lock"
    unlock_address = "https://gitlab.com/api/v4/projects/61363786/terraform/state/poc_tool/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = 5
  }
}
