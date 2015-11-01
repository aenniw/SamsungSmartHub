#!/bin/sh

DISK_DEVICE=$1
MOUNT_POINT=$2
NUM=1
FAT32_ID1="kdosfs"
FAT32_ID2="SDOS5.0"
FAT32_ID3="FAT16"
FAT32_ID4="FAT32"
NTFS_ID1="TFS"

ret_val1=0
ret_val2=0
ret_val3=0
ret_val4=0
ret_val5=0


mkdir -p $MOUNT_POINT
chmod -R 777 $MOUNT_POINT

dd if=$DISK_DEVICE$NUM of=/tmp/out.fat32 count=1
        
grep $FAT32_ID1 /tmp/out.fat32
ret_val1=$?
        
grep $FAT32_ID2 /tmp/out.fat32
ret_val2=$?
        
grep $FAT32_ID3 /tmp/out.fat32
ret_val3=$?
        
grep $FAT32_ID4 /tmp/out.fat32
ret_val4=$?

grep $NTFS_ID1 /tmp/out.fat32
ret_val5=$?
        

if [ $ret_val1 = 0 -o $ret_val2 = 0 -o $ret_val3 = 0 -o $ret_val4 = 0 ]; then
	mount -t vfat -o umask=0000,iocharset=utf8,shortname=winnt $DISK_DEVICE$NUM $MOUNT_POINT

elif [ $ret_val5 = 0 ]; then
    echo "$DISK_DEVICE is NTFS"
	###ntfs-3g $DISK_DEVICE$NUM $MOUNT_POINT
	mount -t ufsd -o umask=0000 $DISK_DEVICE$NUM $MOUNT_POINT
else            
    echo "$device is not FAT32"
    mount -t auto $DISK_DEVICE$NUM $MOUNT_POINT
fi
  
if [ $? != 0 ]; then
	echo "mount $DISK_DEVICE failed !!!"
	exit 1    
fi

exit 0
			