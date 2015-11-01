#!/bin/sh

#CODB_DIR="/system/codb"
CODB_DIR="/usr/sausalito/codb"
SAVE_DIR="/tmpmnt/configuration"
SAVE_FILE_NAME="config.tar"


sh -c '
        killall powermgmt
        sleep 100000
' > /dev/null 2>&1 &
echo BYE SUCCESS

sleep 2


## Kill sausalito server process
killall -9 cced

## remove  /usr/sausalito/codb directory
rm -rf $CODB_DIR


## copy  /tmpmnt/configuration/codb to /usr/sausalito/codb 
cp -a $SAVE_DIR/codb $CODB_DIR

/usr/sausalito/bin/sys_init codb_write
echo "restore config" > /system/.newroot

sync
sync
/etc/rc.d/S01reboot 
