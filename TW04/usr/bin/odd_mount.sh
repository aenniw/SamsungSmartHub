#!/bin/sh

MOUNT_POINT=$1
MOUNT_CDROM=/mnt/cdrom

cddfs -D /dev/sg0 $MOUNT_POINT
ret_val=$?

if [ $ret_val = 0 ]; then
	echo "CDDFS is mounted"
fi
if [ $ret_val != 0 ]; then
	echo "Try to mount ODD filesystem"
	mount -t udf /dev/sr0 $MOUNT_POINT
	if [ $? != 0 ]; then
		mount -t auto /dev/sr0 $MOUNT_POINT
	fi
fi


if [ $? = 0 ]; then
    echo "symlink for sharing on samba"
    if [ -e $MOUNT_CDROM ]; then
        rm -f $MOUNT_CDROM
    fi
    ln -s $MOUNT_POINT $MOUNT_CDROM
fi
						
