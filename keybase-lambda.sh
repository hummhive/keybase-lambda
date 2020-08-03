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
ls -la $HOME
ls -la $HOME/.config
ls -la $HOME/.cache

ps aux | grep -i keybase | grep -v grep
ps aux | grep -i kbfs | grep -v grep
ps aux | grep -i kbfsfuse | grep -v grep

ps aux | grep -i /usr/local/bin/kbfsfuse | grep -v grep
# if kbfsfuse process exits with a match then grep will have a 0 exit code
KBFSFUSE_NOT_RUNNING=$?

if ! (( $KBFSFUSE_NOT_RUNNING == 0 )); then
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

keybase fs read keybase://private/thedavidmeister/foo.txt

ls -la $HOME
ls -la $HOME/.config
ls -la $HOME/.cache

# rm -rf /tmp/tmp*
