#!/bin/bash

set -ueo pipefail
IFS=$'\n\t'

read -p "Enter the IP address or DNS name of your ArgoCD instance: " argocd_host
read -p "Username: " argocd_username
read -p "Current password: " argocd_old_password
read -p "New password: " argocd_new_password

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
argocd login "${argocd_host}"

argocd account update-password \
  --account "${argocd_username}" \
  --current-password "${argocd_old_password}" \
  --new-password "${argocd_new_password}"
