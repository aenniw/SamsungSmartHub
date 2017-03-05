#!/bin/sh

DISK_DEVICE=$1
MOUNT_USBS=/mnt/usbs
FAT32_ID1="kdosfs"
FAT32_ID2="SDOS5.0"
FAT32_ID3="FAT16"
FAT32_ID4="FAT32"
NTFS_ID1="TFS"


do_mount()
{
	DISK_DEVICE_NUM=$1
	MOUNT_POINT=$2
	
	echo "### $DISK_DEVICE_NUM ---> $MOUNT_POINT ###"
	mkdir -p $MOUNT_POINT
	chmod -R 777 $MOUNT_POINT

	ret_val1=0
	ret_val2=0
	ret_val3=0
	ret_val4=0
	ret_val5=0

	dd if=$DISK_DEVICE_NUM of=/tmp/out.fat32 count=1
        
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
    	echo "$DISK_DEVICE_NUM is FAT32"
		#mount -t vfat -o sync,noatime,umask=0000,iocharset=utf8,shortname=winnt $DISK_DEVICE_NUM $MOUNT_POINT
		mount -t vfat -o sync,noatime,umask=0002,iocharset=utf8,shortname=winnt,gid=100 $DISK_DEVICE_NUM $MOUNT_POINT
	elif [ $ret_val5 = 0 ]; then
    	echo "$DISK_DEVICE_NUM is NTFS"
		#mount -t ufsd -o umask=0000,dmask=0000,fmask=0000,sparse,force $DISK_DEVICE_NUM $MOUNT_POINT
		mount -t ufsd -o umask=0002,dmask=0002,fmask=0002,sparse,force,gid=100 $DISK_DEVICE_NUM $MOUNT_POINT
	else            
    	echo "$device is not FAT32"
	    mount -t auto $DISK_DEVICE_NUM $MOUNT_POINT
	fi

	if [ $? != 0 ]; then
		echo "mount $DISK_DEVICE_NUM failed !!!"
		 [ "$(ls -A $MOUNT_POINT)" ] || rm -rf $MOUNT_POINT
	
		#T120308.sg - for smartbackup
		echo "0" > /tmp/sbd/is_disk_on
		return 1
	else
		rm $MOUNT_POINT/.access_conf/status.bin
	fi


	#T120308.sg - for smartbackup
	echo "1" > /tmp/sbd/is_disk_on

	return 0
}

getLabel(){
LABEL=`toybox blkid /dev/$1 | awk '{print $2}' | sed 's/^[^"]*"\([^"]*\)".*/\1/'`;
test -z $LABEL && LABEL=`toybox blkid /dev/$1 | awk '{print $3}' | sed 's/^[^"]*"\([^"]*\)".*/\1/'`;
test -z $LABEL && exit 0;
echo $LABEL;
};

post_mount(){
    ln -s $1 "/mnt/$2";
    /etc/scripts/link-media-files.sh -a $1
    /etc/scripts/smb-share.sh -a $1
};

#######################################################################################
# Main routine for mount - T111211.sg
#######################################################################################

test -d $MOUNT_USBS || mkdir $MOUNT_USBS;

DEVICE=${DISK_DEVICE#/*/}
PARTITIONS=`cat /proc/partitions | awk '{print $4}' | grep ''$DEVICE'[0-9]'`;
if [ -z $PARTITIONS ]; then
	Label=$(getLabel $DEVICE);
	if [ ! -z $Label ]; then
		echo "Z $DISK_DEVICE" >> /tmp/mount.log;
		do_mount $DISK_DEVICE "$MOUNT_USBS/.$Label"
		post_mount "$MOUNT_USBS/.$Label" $Label
	fi
else
	for partition in $PARTITIONS
	do
		Label=$(getLabel $partition);
		if [ ! -z $Label ]; then
			echo "/dev/$partition" >> /tmp/mount.log;
			do_mount /dev/$partition "$MOUNT_USBS/.$Label"
			post_mount "$MOUNT_USBS/.$Label" $Label
		fi
	done
fi
#usbs_usage
/usr/sausalito/handlers/base/usb_disk/usbs_usage.sh >/tmp/usbs_usage

exit 0

