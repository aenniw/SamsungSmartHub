#!/bin/sh

TAR_DIR=$1
REMOTE_URI=$2
TIMEOUT=$3
if [ -z $TIMEOUT ]; then
	TIMEOUT=120
fi

PROGRESS_FILE=/tmp/sbd/se208bwfwPROGRESS

wget -P $TAR_DIR $REMOTE_URI 2>$PROGRESS_FILE &

NUM=1
STALLED_CNT=0
STALLED_TIMEOUT=5
while [ $NUM -le $TIMEOUT ]
do
	pidof wget >/dev/null
	if [ $? -ne 0 ]; then
		exit 0
	else
		grep "stalled" $PROGRESS_FILE >/dev/null
		if [ $? -eq 0 ]; then
			STALLED_CNT=`expr $STALLED_CNT + 1`
			echo STALLED=$STALLED_CNT
		fi

		if [ $STALLED_CNT -le $STALLED_TIMEOUT ]; then
			sleep 1
		else
			killall -9 wget
			exit 2
		fi 
	fi

	NUM=`expr $NUM + 1`
done 


killall -9 wget
exit 1


