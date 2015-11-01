#!/bin/sh

## There are 3 steps
## 1. Make /volume1/config.bak directory
## 2. cp and remove  /usr/sausalito/codb & /usr/hddapp/etc(Not include rc.d) directory
## 3. backup to config.tar.gz.bak file for future use

NUM=2

sh -c '
      sleep 10000
' > /dev/null 2>&1 &
echo BYE SUCCESS

sleep 2

if [ "$1" != "NULL" ]; then
	quotaoff $1$NUM
	rm -rf /*/*/aquota.*
fi
			
killall5 -9 
rm -rf /system/codb
rm -rf /system/hddapp
rm -rf /system/spool
/usr/sausalito/bin/sys_init codb_remove
echo "factory reset" > /system/.newroot
sync
sync
/etc/rc.d/S01reboot 

