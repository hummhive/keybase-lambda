#!/usr/bin/env sh

set -ex

# guard against nix shell
if [[ -z $IN_NIX_SHELL && -z $CI ]]
 then
  echo "run needs to be run from the nix shell"
  exit 1
fi

# move into the directory this script is in
cd "${0%/*}"

# fresh start
rm -rf build
rm -rf runtime

function build {
 name=$1
 tag=hummhive/${name}-lambda
 mkdir -p "runtime/${name}"
 mkdir -p "build/${name}"
 docker build -f "./Dockerfile.${name}build" -t $tag .
 cid=$( docker create $tag )
 docker cp ${cid}:/tmp/build $PWD/build/$name
 docker rm ${cid}
 mv -f ./build/$name/build/* ./runtime/$name
 cp ./bootstrap/$name ./runtime/$name/bootstrap

 (
  cd runtime/$name \
  && chmod +x ./* \
  && zip runtime-$name.zip ./*
 )
}

build keybase
build holochain
