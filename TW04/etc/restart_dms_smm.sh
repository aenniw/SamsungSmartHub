#!/bin/sh

DMS_SMM=/etc/dms_smm.sh
ODD_SHARE_DIR=/usr/local/share/dlna/DMS/data/Optical_Disc


case "$1" in

start)
	$DMS_SMM stop
	pidof dms_smm >/dev/null
	if [ $? -eq 0 ]; then
		echo "sleep 2"
		sleep 2
	fi
	$DMS_SMM start

	# refresh ODD share
	if [ -d $ODD_SHARE_DIR ]; then
		echo "### refresh ODD share ###"
		$DMS_SMM remove cdrom 6311 /mnt/cdrom
		$DMS_SMM add cdrom 6311 /mnt/cdrom
	fi

	# refresh USBS share
	usbs_valid=`cat /proc/partitions | sed -n '$='`
	echo usbs_valid=$usbs_valid
	if [ -z $usbs_valid ]; then
		usbs_valid=0
	fi  

	if [ $usbs_valid -gt 2 ]; then
		echo "### refresh USBS share ###"
		$DMS_SMM remove usb_disk 6312 /mnt/usbs
		$DMS_SMM add usbs_disk 6312 /mnt/usbs
	fi
	;;

*)
	echo "usage: $0 { start }" >&2
	exit 1
	;;

esac
