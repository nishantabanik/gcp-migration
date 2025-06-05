module "dns-policy-googleapis" {
  source     = "git@gitlab.com:psi-software-se/terraform/modules.git//dns-response-policy?ref=stable"
  project_id = var.gcp_project_id 
  name       = "googleapis"
  networks = {
    main = module.vpc.self_link
  }
  rules_file = "data/dns-policy-rules.yaml"
}