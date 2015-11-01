#!/bin/sh
#
# S12syslog.sh - startup script for syslogd
#
# This goes in /usr/storlink/etc/rc.d and gets run at boot-time.

SYSLOGD=/sbin/syslogd
##CONF=/etc/thttpd.conf

case "$1" in

start)
	if [ -x "$SYSLOGD" ] ; then
		echo "start syslogd"
		#$SYSLOGD 
	fi
	;;

stop)
	echo "stop syslogd" 
	##kill -USR1 `cat /var/run/crond.pid`
	killall -q syslogd
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
