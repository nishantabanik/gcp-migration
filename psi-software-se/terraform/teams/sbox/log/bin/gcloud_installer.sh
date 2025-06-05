#!/bin/sh

#google cloud sdk download link: (https://console.cloud.google.com/storage/browser/cloud-sdk-release)

version="496.0.0"
filename="google-cloud-sdk-${version}-linux-x86_64.tar.gz"
url="https://storage.googleapis.com/cloud-sdk-release/${filename}"
checksum="9355cdd311c622f13e2f2a3eb06ffd1b74a1f50a9d1af9eed786cbe0e9a5b736"

apk add --no-cache curl ca-certificates py3-pip python3 coreutils
curl -O "${url}"
echo ${checksum}"  "${filename} | sha256sum -c || exit 1
tar -xzf "${filename}"
./google-cloud-sdk/install.sh --quiet
./google-cloud-sdk/bin/gcloud components install gke-gcloud-auth-plugin --quiet
