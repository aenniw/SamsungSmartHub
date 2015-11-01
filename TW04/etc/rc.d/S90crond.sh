#!/bin/sh
#
# S90crond.sh - startup script for thttpd
#
# This goes in /usr/storlink/etc/rc.d and gets run at boot-time.

CROND=/usr/sbin/crond
##CONF=/etc/thttpd.conf

case "$1" in

start)
	if [ -x "$CROND" ] ; then
		echo "start crond"
		$CROND 
	fi
	;;

stop)
	echo "stop crond" 
	##kill -USR1 `cat /var/run/crond.pid`
	killall -q crond
	;;

restart)
	$0 stop
	$0 start
	;;

*)
	echo "usage: $0 { start | stop | restart }" >&2
	exit 1
	;;

esac
