#module "db" {
#  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//cloudsql-instance?ref=stable"
#  project_id = var.gcp_project_id
#  network_config = {
#    connectivity = {
#      psa_config = {
#        private_network = module.vpc.self_link
#      }
#      # psc_allowed_consumer_projects = [var.project_id]
#    }
#  }
#  name             = "mes-test-infrastructure"
#  region           = var.gcp_region
#  database_version = "POSTGRES_16"
#  tier             = "db-custom-2-7680"
#  disk_size        = 10
#  disk_type        = "PD_SSD"
#  databases = [
#    "argocd",
#  ]
#  users = {
#    argocd = {
#      type     = "BUILT_IN"
#    }
#  }
#  gcp_deletion_protection       = false
#  terraform_deletion_protection = false
#}