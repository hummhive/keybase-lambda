#!/usr/bin/env sh

set -euo pipefail

# guard against nix shell
if [[ -z $IN_NIX_SHELL ]]
 then
  echo "deploy needs to be run from the nix shell"
  exit 1
fi

# move into the directory this script is in
cd "${0%/*}"

rm -rf .deploy
mkdir .deploy

docker build \
  --build-arg PAPERKEY="$keybase_paperkey" \
  --build-arg VERSION="$keybase_version" \
  -f Dockerfile.keybasebuild \
  -t hummhive:keybase-lambda \
  .
