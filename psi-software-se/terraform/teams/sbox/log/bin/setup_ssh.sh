#!/bin/sh

CICD_MODULES_KEY=$1
SSH_AUTH_SOCK=$2

ssh-agent -a "$SSH_AUTH_SOCK"
echo "$CICD_MODULES_KEY" | ssh-add -
mkdir -p ~/.ssh
echo "Adding GitLab's SSH key to known hosts..."
ssh-keyscan -H 'gitlab.com' >> ~/.ssh/known_hosts
ssh-keyscan gitlab.com | sort -u - ~/.ssh/known_hosts -o ~/.ssh/known_hosts
