#!/bin/sh

set -x
set -ue

mkdir -p .git

git config -f .git/config user.name "GitLab CI"
git config -f .git/config user.email "gitlab_ci@$CI_SERVER_HOST"

git reset --hard
git pull --rebase "${CI_REPOSITORY_URL}" "${CI_COMMIT_BRANCH}"
