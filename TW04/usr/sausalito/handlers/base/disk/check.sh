#!/bin/sh

DISK_NAME=$1
DISK_TYPE=$2
MOUNT_POINT=$3
PARTION_NUM=$4
PAR_NAME=$DISK_NAME$PARTION_NUM


sh -c '
      sleep 10000
' > /dev/null 2>&1 &
echo BYE SUCCESS

echo "" > /tmp/disk.check

ret_ver=0


if [ "$DISK_TYPE" = "vfat" ]; then
    dosfsck -a $PAR_NAME
    if [ $? != 0 ]; then 
        mount -t vfat -o umask=0000,iocharset=utf8,shortname=winnt $PAR_NAME $MOUNT_POINT
		echo "check error" > /tmp/disk.check
       	killall sleep
       	exit 0  
    else
        mount -t vfat -o umask=0000,iocharset=utf8,shortname=winnt $PAR_NAME $MOUNT_POINT
    fi    

elif [ "$DISK_TYPE" = "msdos" ]; then
	dosfsck -a $PAR_NAME
    if [ $? != 0 ]; then 
      	mount -t msdos -o umask=0000 $PAR_NAME $MOUNT_POINT
	 	echo "check error" > /tmp/disk.check
       	killall sleep
       	exit 0  
    else
         mount -t msdos -o umask=0000 $PAR_NAME $MOUNT_POINT
    fi	
      
elif [ "$DISK_TYPE" = "xfs" ]; then
    fsck.xfs $PAR_NAME
    if [ $? != 0 ]; then
       	mount -t xfs -o usrquota,grpquota $PAR_NAME $MOUNT_POINT
       	echo "check error" > /tmp/disk.check
       	killall sleep
       	exit 0  
    else
        mount -t xfs -o usrquota,grpquota $PAR_NAME $MOUNT_POINT
    fi
elif [ "$DISK_TYPE" = "ufsd" ]; then
    chkntfs $PAR_NAME
    if [ $? != 0 ]; then
       	mount -t ufsd -o umask=0000 $PAR_NAME $MOUNT_POINT
       	echo "check error" > /tmp/disk.check
       	killall sleep
       	exit 0  
    else
       	mount -t ufsd -o umask=0000 $PAR_NAME $MOUNT_POINT
    fi
else
    e2fsck -p $PAR_NAME
    if [ $? != 0 ]; then
       mount -t auto -o usrquota,grpquota $PAR_NAME $MOUNT_POINT
       echo "check error" > /tmp/disk.check
       killall sleep
       exit 0  
  	else
        mount -t auto -o usrquota,grpquota $PAR_NAME $MOUNT_POINT
    fi
fi
		
echo "Complete" > /tmp/disk.check
killall sleep
exit 0