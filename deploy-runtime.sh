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
 region=us-east-1
 long_name="test-$name-runtime"
 if (( $( aws efs describe-file-systems --creation-token $long_name --region $region | jq ".FileSystems | length" ) == 0 ))
  then
   aws efs create-file-system --creation-token $long_name --region $region
 fi
 aws s3 cp "./runtime/$name/runtime-$name.zip" "s3://humm-test/runtime-$name.zip"
 aws lambda update-function-code --function-name $long_name --region $region --s3-bucket humm-test --s3-key "runtime-$name.zip"
}

deploy keybase
deploy holochain
