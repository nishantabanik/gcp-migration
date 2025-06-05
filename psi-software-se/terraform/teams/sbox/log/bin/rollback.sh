#!/bin/sh

set -x
set -ue

NUMBER_OF_PARENTS=$(git show --no-patch --format="%P" HEAD | wc -w)
if [ "$NUMBER_OF_PARENTS" -gt 1 ]; then
    git revert --no-edit "$CI_COMMIT_SHA" -m 1
    git push "https://gitlab_bot_psi_se:${GITLAB_PUSH_TOKEN}@${CI_SERVER_HOST}/${CI_PROJECT_PATH}.git" "HEAD:${CI_COMMIT_REF_NAME}"
fi
