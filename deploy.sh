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

# ensure the deploy folder exists
mkdir -p .deploy

# copy the amazone-built keybase client into it
docker run --rm -v $PWD/.deploy:/deploy hummhive:keybase-lambda

zip .deploy/keybase.zip .deploy/keybase
zip .deploy/kbfsfuse.zip .deploy/kbfsfuse

serverless deploy
