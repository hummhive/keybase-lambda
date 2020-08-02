#!/usr/bin/env bash

set -euxo pipefail

echo "start keybase lambda"
whoami
echo $KEYBASE_USERNAME
echo $KEYBASE_PAPERKEY
echo $KEYBASE_SERVICE
# echo $XDG_RUNTIME_DIR
# echo $XDG_CONFIG_DIR
# echo $XDG_RUNTIME_USER
echo $HOME

du -hs $TMP/*

# keybase status -j
keybase fs read keybase://private/thedavidmeister/foo.txt
