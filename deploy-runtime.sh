#!/usr/bin/env sh

set -euxo pipefail

# guard against nix shell
if [[ -z $IN_NIX_SHELL ]]
 then
  echo "run needs to be run from the nix shell"
  exit 1
fi

# move into the directory this script is in
cd "${0%/*}"

mkdir -p build
mkdir -p runtime

docker build -f ./Dockerfile.keybasebuild -t hummhive/keybase-lambda .
docker run --rm -v $PWD/build:/build -it hummhive/keybase-lambda
( cd build && sudo chown -R `whoami`:users . )
mv -f ./build/* ./runtime

cp ./bootstrap ./runtime/bootstrap
cd runtime
ls -la
chmod +x ./*
zip runtime.zip ./*
aws s3 cp ./runtime.zip s3://humm-test/runtime.zip
aws lambda update-function-code --function-name test-bootstrap --region us-east-1 --s3-bucket humm-test --s3-key runtime.zip
