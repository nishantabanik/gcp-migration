#!/bin/sh

GOOGLE_PROJECT=$1
wif_provider=$2
google_credentials=$3
SERVICE_ACCOUNT=$4

gcloud config configurations create "${GOOGLE_PROJECT}"
gcloud iam workload-identity-pools create-cred-config \
  "$wif_provider" \
  --service-account="${SERVICE_ACCOUNT}" \
  --service-account-token-lifetime-seconds=900 \
  --output-file="$google_credentials" \
  --credential-source-file=token.txt
gcloud config set auth/credential_file_override "$google_credentials"
gcloud config set project "${GOOGLE_PROJECT}"

