#!/bin/sh

MOUNTS=`df | grep 'sd' | awk '{print $1,$6}'`
PARTITIONS=`cat /proc/partitions | grep 'sd' | awk '{print $4}'`

#T120308.sg - for smartbackup
echo "0" > /tmp/sbd/is_disk_on

post_unmount(){
    /etc/scripts/link-media-files.sh -r $1
    /etc/scripts/smb-share.sh -r $1
};

UMOUNT=true;
HAVE_PATH=false;
for mount in $MOUNTS
do
	if [ $HAVE_PATH = true ]; then
		HAVE_PATH=false;
		if [ $UMOUNT = true ]; then
			umount $mount;
			post_unmount $mount
			toybox rmdir $mount;
		else
			echo "1" > /tmp/sbd/is_disk_on;
		fi
	else
		UMOUNT=true;
		for mounted in $PARTITIONS
		do
			if [ ${mount#/*/} = $mounted ]; then
				UMOUNT=false;
				break;
			fi
		done
		HAVE_PATH=true;
	fi	
done

rm /tmp/usbs_usage
/usr/sausalito/handlers/base/usb_disk/usbs_usage.sh >/tmp/usbs_usage

