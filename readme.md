export BUILD=`uuidgen`
scar init -i thedavidmeister/scarkeybase3:latest -n $BUILD -e KEYBASE_PAPERKEY="$KEYBASE_PAPERKEY" -e KEYBASE_USERNAME="thedavidmeister" -e HIVE_KEYBASE_PATH="keybase://team/humm_provenance" -e HIVE_PUBKEY=CSCDkUyH3Ymdzmbcf
e/OX9EeQg7DvoPRIYWKmcUNKAc=
scar run -n $BUILD
