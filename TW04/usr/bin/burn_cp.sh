#!/bin/sh

BURN_COMPLETE_DIR=/tmp/sbd
BURN_COMPLETE_FILE=$BURN_COMPLETE_DIR/burn_complete
IS_DISK_ON_FILE=$BURN_COMPLETE_DIR/is_disk_on
SRC=$1
DST=$2

if [ -z $SRC ]; then
	exit 1
fi

if [ -z $DST ]; then
	exit 2
fi

echo "0" > $BURN_COMPLETE_FILE
cpr
RET=$?

if [ $RET -eq 0 ]; then
	is_disk_on=`cat $IS_DISK_ON_FILE`
	echo "! is_disk_on = $is_disk_on"
	if [ $is_disk_on -eq 1 ]; then
		echo "1" > $BURN_COMPLETE_FILE
	fi
fi
