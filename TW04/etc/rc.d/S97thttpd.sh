#!/bin/sh
#
# S98thttpd.sh - startup script for thttpd
#
# This goes in /usr/storlink/etc/rc.d and gets run at boot-time.

THTTPD=/usr/sbin/thttpd
CONF=/etc/thttpd.conf

case "$1" in

start)
	if [ -x "$THTTPD" ] ; then
		echo "start thttpd"
		$THTTPD -C $CONF
	fi
	;;

stop)
	echo "stop thttpd"
	kill -USR1 `cat /var/run/thttpd.pid`
	;;

*)
	echo "usage: $0 { start | stop }" >&2
	exit 1
	;;

esac
