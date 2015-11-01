#!/bin/sh
#
# watchcatd.sh - startup script for watchcatd 
#

WCC=/usr/bin/watchcatd

case "$1" in

start)
	if [ -x "$WCC" ] ; then
		echo "start watchcatd"
		$WCC 1500000 2>/dev/null 
	fi

	
	# install usb driver
    lsmod | grep ehci_hcd_FOTG2XX
	if [ $? -ne 0 ]; then
	    insmod /lib/modules/ehci-hcd-FOTG2XX-1.ko
	fi

	# excute monitor program 
	pidof monitor_sam
	if [ $? -ne 0 ]; then
    	/etc/monitor_sam &
	fi

	;;

stop)
	echo "stop watchcatd"
	killall watchcatd
	;;

*)
	echo "usage: $0 { start | stop }" >&2
	exit 1
	;;

esac
