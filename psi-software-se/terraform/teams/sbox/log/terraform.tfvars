project_id        = "psi-de-0-sandbox-log"
region            = "europe-west3"
zone              = "europe-west3-a"
network           = "vpc-ew3"
subnetwork        = "vpc-ew3-subnet-0"
impersonate_service_account = "psi-de-0-sb-sandbox-log-0@psi-de-0-sandbox-log.iam.gserviceaccount.com"
iap                   = {
  enabled = true
  email   = "tbenning@psi.de"
}

