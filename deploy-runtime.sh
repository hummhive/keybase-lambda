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

./build-runtime.sh

function deploy {
 name=$1
 aws s3 cp "./runtime/$name/runtime-$name.zip" "s3://humm-test/runtime-$name.zip"
 aws lambda update-function-code --function-name "test-$name-runtime" --region us-east-1 --s3-bucket humm-test --s3-key "runtime-$name.zip"
}

deploy keybase
deploy holochain
