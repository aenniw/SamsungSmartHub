#!/bin/sh
#
# smartbackupd.sh - startup script for smartbackupd 
#

SBDPATH=/usr/bin/smartbackupd
SBD=smartbackupd
PIDFILE=/var/run/smartbackupd.pid
WATCHOUT_RUN_DIR=/tmp/sbd/watchout_run


case "$1" in

start)
	if [ -x "$SBDPATH" ] ; then
		echo "start smartbackupd"
		if [ -e $WATCHOUT_RUN_DIR/smartbackupd ]; then
			echo 1 >$WATCHOUT_RUN_DIR/smartbackupd
			$SBD
			pidof $SBD > $PIDFILE
		else
			echo 1 >$WATCHOUT_RUN_DIR/smartbackupd
			#$SBD
			pidof $SBD > $PIDFILE
		fi
	fi
	
	;;

stop)
	echo "stop smartbackupd"
	killall smartbackupd
	echo 0 >$WATCHOUT_RUN_DIR/smartbackupd
	rm -rf $PIDFILE
	;;

*)
	echo "usage: $0 { start | stop }" >&2
	exit 1
	;;

esac
