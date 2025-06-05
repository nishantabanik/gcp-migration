#!/bin/bash

# Copyright 2024 Slalom GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Create PSI groups in Google Cloud Identity.

# PSI dev teams
MY_TEAMS=(
  'sample'
)

# Storage location
MY_FAST_CONFIG="$HOME/fast-config"

# User input
MY_ORG_NAME="${1:-psi.de}"
MY_PROJECT_ID="${2:-psi-de-0-prod-iac-core-0}"

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  cat <<END
Create PSI groups in Google Cloud Identity.

Usage:
  groups.sh [ORGANIZATION_DISPLAY_NAME] [IAC_CORE_PROJECT_ID]

Example with automatic configuration:
  groups.sh

Example with manual configuration:
  groups.sh gcp.example.com fu-bar-prod-iac-core-0
END
  exit 0
fi

for MY_TEAM in "${MY_TEAMS[@]}"; do
    MY_TEAM_ID=$(echo "$MY_TEAM" | perl -ne 'print lc')
    MY_GROUP_EMAIL="gcp-team-${MY_TEAM_ID}@$MY_ORG_NAME"
    MY_GROUP_ADMIN_EMAIL="gcp-team-${MY_TEAM_ID}-admins@$MY_ORG_NAME"

    echo
    echo "Team: $MY_TEAM ($MY_TEAM_ID)"
    echo
    echo "- $MY_GROUP_EMAIL"
    gcloud identity groups create "$MY_GROUP_EMAIL" \
    --project="$MY_PROJECT_ID" \
    --organization="$MY_ORG_NAME" \
    --group-type="security" \
    --display-name="gcp-team-${MY_TEAM_ID}" \
    --description="Team $MY_TEAM" \
    --quiet
    echo
    echo "- $MY_GROUP_ADMIN_EMAIL"
    gcloud identity groups create "$MY_GROUP_ADMIN_EMAIL" \
    --project="$MY_PROJECT_ID" \
    --organization="$MY_ORG_NAME" \
    --group-type="security" \
    --display-name="gcp-team-${MY_TEAM_ID}-admins" \
    --description="Team $MY_TEAM (Admins)" \
    --quiet
done

echo
echo "DONE"