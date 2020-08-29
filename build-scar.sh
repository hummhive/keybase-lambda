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
 -f Dockerfile.scar \
 --build-arg KEYBASE_PAPERKEY="$KEYBASE_PAPERKEY" \
 --build-arg AWS_SECRET="$AWS_SECRET_ACCESS_KEY" \
 --build-arg AWS_ID="$AWS_ACCESS_KEY_ID" \
 --build-arg AWS_ROLE="$AWS_ROLE" \
 -t scar .
docker build -f Dockerfile.scarkeybase -t thedavidmeister/scarkeybase .
docker push thedavidmeister/scarkeybase
