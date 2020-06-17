#!/usr/bin/env sh

set -euxo pipefail

# guard against nix shell
if [[ -z $IN_NIX_SHELL ]]
 then
  echo "deploy needs to be run from the nix shell"
  exit 1
fi

# move into the directory this script is in
cd "${0%/*}"

docker run --rm -v "$PWD":/var/task:ro,delegated lambci/lambda:nodejs12.x handler.hello
