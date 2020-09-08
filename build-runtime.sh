#!/usr/bin/env sh

set -eux

# guard against nix shell
if [[ -z $IN_NIX_SHELL && -z $CI ]]
 then
  echo "run needs to be run from the nix shell"
  exit 1
fi

# move into the directory this script is in
cd "${0%/*}"

rm -rf build
rm -rf runtime
mkdir -p build
mkdir -p runtime

docker build -f ./Dockerfile.keybasebuild -t hummhive/keybase-lambda .
cid=$( docker create hummhive/keybase-lambda )
docker cp ${cid}:/tmp/build $PWD
docker rm ${cid}

mv -f ./build/* ./runtime

cp ./bootstrap ./runtime

cd runtime
chmod +x ./*
zip runtime.zip ./*
