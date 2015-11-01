#!/bin/sh

MOUNT_POINT=/mnt/cdrom

if [ ! -d $MOUNT_POINT ]; then
	mkdir -p $MOUNT_POINT
fi

cddfs -D /dev/sg0 $MOUNT_POINT
ret_val=$?

if [ $ret_val = 0 ]; then
	echo "CDDFS is mounted"
fi
if [ $ret_val != 0 ]; then
	echo "Try to mount ODD filesystem"
	#mount -t udf /dev/sr0 $MOUNT_POINT
	#if [ $? != 0 ]; then
		mount -t auto /dev/sr0 $MOUNT_POINT
	#fi
fi

