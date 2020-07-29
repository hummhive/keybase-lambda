#!/usr/bin/env sh

# guard against nix shell
if [[ -z $IN_NIX_SHELL ]]
 then
  echo "run needs to be run from the nix shell"
  exit 1
fi

# move into the directory this script is in
cd "${0%/*}"

# mkdir -p $PWD/.scar
# mkdir -p $PWD/.aws
# chown 100:101 $PWD/.scar

docker run \
  --rm \
  -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
  -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
  -it \
  scar

  # -v $PWD/.aws:/home/scar/.aws \
  # -v $PWD/.scar:/home/scar/.scar \

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
