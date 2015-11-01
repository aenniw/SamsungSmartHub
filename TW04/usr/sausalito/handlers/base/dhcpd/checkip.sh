#!/bin/sh

LAN_DEV=$1

KEYWORD="inet addr:"
TMP_FILE="/tmp/ip.tmp"


ifconfig $LAN_DEV > $TMP_FILE
CHK_EXIST=`eval "grep $KEYWORD $TMP_FILE"` 
if [ "$CHK_EXIST" != "" ]; then
	exit 0    
fi



