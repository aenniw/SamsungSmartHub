#!/bin/sh

SCSI_DIR=$1
FILE=$2
ROOT="/proc/scsi/"
SCSI_PATH=$ROOT$SCSI_DIR

if [ -z $SCSI_DIR ]; then
    exit 0
fi

if [ -z $FILE ]; then
    exit 0
fi

cd $SCSI_PATH

cat $FILE | grep Attached > /tmp/sdisk.info

awk '{print $2}' /tmp/sdisk.info > /tmp/sdisk.tmp
