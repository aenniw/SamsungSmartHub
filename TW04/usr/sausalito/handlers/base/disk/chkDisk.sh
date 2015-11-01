#!/bin/sh

DISK_NAME=$1
PARTION_NUM=$2
PARTION_NUM1=1
PAR_NAME1=$DISK_NAME$PARTION_NUM1
PAR_NAME=$DISK_NAME$PARTION_NUM
TMP_FILE="/tmp/disk.tmp"
INFO_FILE="/tmp/disk.info"
HD_IMG_FILE="/ImageInfo"
SYSTEM_FILE="/system"

if [ -z $DISK_NAME ]; then
    exit 0
fi

df $PAR_NAME1 > $TMP_FILE
CHK_EXIST=`eval "grep $SYSTEM_FILE $TMP_FILE"`
##### /dev/?1 mount on /system
if [ "$CHK_EXIST" = "" ]; then
		df $PAR_NAME1 > $TMP_FILE
		CHK_MOUNT=`eval "grep $PAR_NAME1 $TMP_FILE"`
		if [ "$CHK_MOUNT" = "" ]; then
##### No disk mount, Check hard disk exist or not
  			CHK_DISK=`eval "fdisk $DISK_NAME -l"`
    		if [ "$CHK_DISK" = "" ]; then
      			exit 0 
    		else
		     		exit 1
    		fi
    else
##### Disk mounted, send the disk infor to disk.info file
  			sed '1ds/ \{1,20\}/ /g' $TMP_FILE | awk -F '[ ]' '{print$2}' > $INFO_FILE
    		sed '1ds/ \{1,20\}/ /g' $TMP_FILE | awk -F '[ ]' '{print$3}' >> $INFO_FILE
    		mount | grep $PAR_NAME1 | awk -F '[ ]' '{print$3}' >> $INFO_FILE
    		mount | grep $PAR_NAME1 | awk -F '[ ]' '{print$5}' >> $INFO_FILE    
    		exit 2
		fi
else
##### /dev/?6 mount on /volume?
		df $PAR_NAME > $TMP_FILE
		sed '1ds/ \{1,20\}/ /g' $TMP_FILE | awk -F '[ ]' '{print$2}' > $INFO_FILE
 		sed '1ds/ \{1,20\}/ /g' $TMP_FILE | awk -F '[ ]' '{print$3}' >> $INFO_FILE
 		mount | grep $PAR_NAME | awk -F '[ ]' '{print$3}' >> $INFO_FILE
 		mount | grep $PAR_NAME | awk -F '[ ]' '{print$5}' >> $INFO_FILE    
 		exit 2
fi

