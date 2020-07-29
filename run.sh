#!/usr/bin/env sh

# guard against nix shell
if [[ -z $IN_NIX_SHELL ]]
 then
  echo "run needs to be run from the nix shell"
  exit 1
fi

# move into the directory this script is in
cd "${0%/*}"

export kbfile=keybase://private/thedavidmeister/foo.txt
export kbbin=/var/task/.deploy/keybase

# docker run \
#  --rm \
#  -v "$PWD":/var/task:ro,delegated \
#  -e KEYBASE_PAPERKEY="$keybase_paperkey" \
#  -e KEYBASE_USERNAME=thedavidmeister \
#  -e XDG_RUNTIME_DIR=/tmp \
#  -e XDG_CONFIG_DIR=/tmp \
#  -e XDG_RUNTIME_USER=/tmp \
#  -e HOME=/tmp \
#  -e kbfile=$kbfile \
#  -e kbbin=$kbbin \
#  --entrypoint bash \
#  -it \
#  lambci/lambda:nodejs12.x

# -v "$PWD":/var/task:ro,delegated \
docker run \
  --rm \
  -e KEYBASE_PAPERKEY="$keybase_paperkey" \
  -e KEYBASE_USERNAME="thedavidmeister" \
  -e KEYBASE_SERVICE="1" \
  -e kbfile="$kbfile" \
  -it \
  keybaseio/client \
  keybase fs read "$kbfile"
