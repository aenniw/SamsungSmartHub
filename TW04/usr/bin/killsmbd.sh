#!/bin/sh

MOUNT_ODD=/mnt/cdrom
smbds=`pidof smbd`

for proc_smbd in $smbds
do
	ls /proc/$proc_smbd -l | grep $MOUNT_ODD >/dev/null
	ret_val=$?
	
	if [ $ret_val -eq 0 ];then
		echo "kill $proc_smbd"
		kill -9 $proc_smbd
		umount $MOUNT_ODD
	fi
done

pidof cddfs
if [ $? -eq 0 ];then
	echo "killall cddfs"
	killall cddfs
fi
	










