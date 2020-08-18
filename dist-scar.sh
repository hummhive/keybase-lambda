#!/usr/bin/env sh

# guard against nix shell
if [[ -z $IN_NIX_SHELL ]]
 then
  echo "run needs to be run from the nix shell"
  exit 1
fi

# move into the directory this script is in
cd "${0%/*}"

docker build \
 -f Dockerfile.scar2 \
 -t dist-scar \
 .
docker run --rm -v "$PWD/dist":/scar/dist -it dist-scar
