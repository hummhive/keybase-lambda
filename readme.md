export BUILD=`uuidgen`
scar init -i thedavidmeister/scarkeybase3 -n $BUILD -e KEYBASE_PAPERKEY="$KEYBASE_PAPERKEY" -e KEYBASE_USERNAME="thedavidmeister"
scar run -n $BUILD
