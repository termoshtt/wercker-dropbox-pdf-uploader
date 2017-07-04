#!/bin/bash

set -eu

token=${DROPBOX_API_TOKEN}
repo=${WERCKER_GIT_REPOSITORY:-WerckerCLI}
branch=${WERCKER_GIT_BRANCH}
sha=${WERCKER_GIT_COMMIT}

echo "Repo   : ${repo}"
echo "Branch : ${branch}"
echo "SHA    : ${sha}"

for pdf in *.pdf; do
  curl -X POST https://content.dropboxapi.com/2/files/upload \
      --header "Authorization: Bearer ${token}" \
      --header "Dropbox-API-Arg: {\"path\": \"/${repo}/${branch}/${pdf}\",\"mode\": \"overwrite\"}" \
      --header "Content-Type: application/octet-stream" \
      --data-binary @${pdf}
  curl -X POST https://content.dropboxapi.com/2/files/upload \
      --header "Authorization: Bearer ${token}" \
      --header "Dropbox-API-Arg: {\"path\": \"/${repo}/_hash/${sha}/${pdf}\",\"mode\": \"overwrite\"}" \
      --header "Content-Type: application/octet-stream" \
      --data-binary @${pdf}
done
