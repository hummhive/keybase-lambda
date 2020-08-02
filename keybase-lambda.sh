#!/usr/bin/env bash

set -x

mkdir -p /tmp/.cache
mkdir -p /tmp/.config

echo "start keybase lambda"
whoami
echo $KEYBASE_USERNAME
echo $KEYBASE_PAPERKEY
echo $KEYBASE_SERVICE
# echo $XDG_RUNTIME_DIR
# echo $XDG_CONFIG_DIR
# echo $XDG_RUNTIME_USER
echo $HOME

df -h
ls -la /tmp
# ls -la /tmp/kbfs
ls -la /home/keybase
ls -la /home/keybase/.config
ls -la /home/keybase/.cache

if [ ! -f '/tmp/.config/keybase/keybased.sock' ]; then
 echo 'starting services'

 KEYBASE_SERVICE_ARGS="-debug -use-default-log-file ${KEYBASE_SERVICE_ARGS:-""}"
 keybase $KEYBASE_SERVICE_ARGS service &

 KEYBASE_KBFS_ARGS="-debug -log-to-file ${KEYBASE_KBFS_ARGS:-"-mount-type=none"}"
 KEYBASE_DEBUG=1 kbfsfuse $KEYBASE_KBFS_ARGS &

 keybase ctl wait --include-kbfs
fi

keybase status | grep -i 'logged in:' | grep -iq 'no'
# if logged in then finding 'no' will have a 0 exit code
LOGGED_IN=$?
if (( $LOGGED_IN == 0 )) ; then
 echo 'logging in'
 keybase --no-auto-fork --no-debug oneshot
fi


ls -la $HOME
ls -la $HOME/.config
ls -la $HOME/.cache

# keybase oneshot
keybase fs read keybase://private/thedavidmeister/foo.txt
# keybase logout

# ls -la /tmp/kbfs
ls -la $HOME
ls -la $HOME/.config
ls -la $HOME/.cache

# rm -rf /tmp/tmp*
# rm -rf /tmp/.cache
