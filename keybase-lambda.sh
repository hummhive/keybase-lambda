#!/usr/bin/env bash

jwt=$( cat $INPUT_FILE_PATH | jq '.jwt' )

humm_jwt_check --jwt=$jwt --pubkey=$HIVE_PUBKEY
jwt_valid=$?
if (( $jwt_valid > 0 )) ; then
 exit $jwt_valid
fi

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

# @todo - increase the parallelization in xargs
# would speed things up for many files but needs better output logic
# specifically, parallel output to a single file interleaves each line which is
# very bad obviously
keybase fs ls -1 -a --rec $HIVE_KEYBASE_PATH | grep .json | xargs -n 1 -P 1 -I "{}" keybase fs read $HIVE_KEYBASE_PATH/{} > items.json

cat items.json | jq -n '.items |= [inputs]'
