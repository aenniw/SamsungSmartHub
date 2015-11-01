#!/bin/sh
#
# prodvd.sh - startup script for DVD Player 
#

SDS=/usr/bin/SmartHub_DS
SDS_PID=/var/run/SmartHub_DS.pid

case "$1" in

start)
	if [ -x "$SDS" ] ; then
		pidof SmartHub_DS >/dev/null
		if [ $? -ne 0 ]; then
			echo "start SmartHub DVD Server"
			$SDS /mnt/cdrom
		else
			echo "SmartHub DVD Server is already running"
		fi

	fi
	;;

stop)
	echo "stop SmartHub DVD Server"
	
	pidof SmartHub_DS >/dev/null
	if [ $? -eq 0 ]; then
		pidof SmartHub_DS | awk {'print $1}' > $SDS_PID
		kill -9 `cat $SDS_PID`
		#killall PMS
		rm $SDS_PID
	fi
	;;


*)
	echo "usage: $0 { start | stop }" >&2
	exit 1
	;;

esac
