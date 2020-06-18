export kbfile=keybase://private/thedavidmeister/foo.txt
export kbbin=/var/task/.deploy/keybase

$kbbin config set mountdir /tmp/keybase
$kbbin config set kbfs.mode constrained
$kbbin --enable-bot-lite-mode oneshot
$kbbin --enable-bot-lite-mode --debug fs read $kbfile
