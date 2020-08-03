#!/usr/bin/env bash

ps aux | grep -i /usr/local/bin/kbfsfuse | grep -qv grep
# if kbfsfuse process exits with a match then grep will have a 0 exit code
KBFSFUSE_NOT_RUNNING=$?

if ! (( $KBFSFUSE_NOT_RUNNING == 0 )); then
 echo 'starting services'

 keybase $KEYBASE_SERVICE_ARGS service &

 kbfsfuse $KEYBASE_KBFS_ARGS &

 keybase ctl wait --include-kbfs
fi

keybase status | grep -i 'logged in:' | grep -iq 'no'
# if logged in then finding 'no' will have a 0 exit code
LOGGED_IN=$?
if (( $LOGGED_IN == 0 )) ; then
 keybase --no-auto-fork --no-debug oneshot
fi

keybase fs read keybase://private/thedavidmeister/foo.txt
