#!/bin/sh

sh -c '
        killall -SIGINT mDNSResponderPosix
        killall powermgmt
        sleep 5
        killall -TERM cced
        sync
        sync
        /etc/rc.d/S01halt
' > /dev/null 2>&1 &

echo BYE SUCCESS
