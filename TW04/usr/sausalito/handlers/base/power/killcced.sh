#!/bin/sh


sh -c '
       sleep 2
       killall5 -9 
       rm -rf /system/usr
       rm -rf /system/hddapp
       rm -rf /system/spool
       sync
       sync
       /etc/rc.d/S01reboot 
' > /dev/null 2>&1 &

echo BYE SUCCESS
exit 0