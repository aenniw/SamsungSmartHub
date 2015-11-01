#!/bin/sh
#
# S81setconf.sh - startup script for setconf 
#

SETCONF=/etc/setconf
mkdir -p /tmp/sbd

case "$1" in

start)
	if [ -x "$SETCONF" ]; then

		echo "start setconf"
		$SETCONF
	fi
	;;

stop)
	echo "stop setconf"
	;;

*)
	echo "usage: $0 { start | stop }" >&2
	exit 1
	;;

esac
