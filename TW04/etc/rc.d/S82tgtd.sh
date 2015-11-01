#!/bin/sh

# This is an example init.d script for stopping/starting/reconfiguring tgtd.

#TGTD_CONFIG=/etc/tgt/targets.conf


enabled=0
enabled=`cat /tmp/sbd/tgtd_enable`

if [ $enabled -ne 1 ]; then
	echo "1" >/tmp/sbd/tgtd_enable
	return 0;
fi


TASK=$1

TARGET_NAME_PATH_NAME=/tmp/sbd/iscsi_target
TARGET_NAME="iqn.2011-11.com.tsstk:storgae.odd.sys"


if [ -e $TARGET_NAME_PATH_NAME ]; then
	TARGET_NAME=`cat $TARGET_NAME_PATH_NAME`
fi
if [ -z $TARGET_NAME ]; then
	TARGET_NAME="iqn.2011-11.com.tsstk:storgae.odd.sys"
fi


start()
{
	# Start tgtd first.
	
	pidof tgtd >/dev/null
	if [ $? -ne 0 ] ; then
		echo "Starting target framework daemon"
		tgtd &>/dev/null
	else
	    echo "tgtd is already running"
	fi

	sleep 2
	
	# Put tgtd into "offline" state until all the targets are configured.
	# We don't want initiators to (re)connect and fail the connection
	# if it's not ready.
	tgtadm --op update --mode sys --name State -v offline

	# Configure the targets.
	#tgt-admin -e -c $TGTD_CONFIG
	#tgtadm --lld iscsi --mode target --op new --tid 1 -T 2011.01.com.tsstk:storage.odd.sys

	tgtadm --lld iscsi --mode target --op show --tid 1 2>/dev/null
	retval_tid=$?

	if [ $retval_tid -ne 0 ]; then 
		tgtadm --lld iscsi --mode target --op new --tid 1 -T "$TARGET_NAME"
		tgtadm --lld iscsi --mode target --op update --tid 1 --name MaxRecvDataSegmentLength --value 65536
		tgtadm --lld iscsi --mode target --op update --tid 1 --name MaxXmitDataSegmentLength --value 65536
		tgtadm --lld iscsi --mode target --op update --tid 1 --name InitialR2T --value No
	fi



	if [ -e /sys/block/sr0 ]; then
		echo "Configure logicalunit"
		if [ $retval_tid -ne 0 ]; then
			tgtadm --lld iscsi --mode logicalunit --op new --tid 1 --lun 1 --bstype=sg --device-type=pt -b /dev/sg0
		fi
		tgtadm --lld iscsi --mode target --op bind --tid 1 -I ALL

		# Put tgtd into "ready" state.
		tgtadm --op update --mode sys --name State -v ready
	fi
}

stop()
{
	echo "Stopping target framework daemon"
	# Remove all targets. It only removes targets which are not in use.
	#tgt-admin --update ALL -c /dev/null &>/dev/null
	# tgtd will exit if all targets were removed
	tgtadm --lld iscsi --mode target --op unbind --tid 1 -I ALL
	RETVAL=$?
	if [ "$RETVAL" -eq 107 ] ; then
	    echo "tgtd is not running"
	    [ "$TASK" != "restart" ] && exit 1
	elif [ "$RETVAL" -ne 0 ] ; then
	    echo "Some initiators are still connected - could not stop tgtd"
	    exit 2
	fi
	echo -n
}

forcedstop()
{
	# NOTE: Forced shutdown of the iscsi target may cause data corruption
	# for initiators that are connected.
	echo "Force-stopping target framework daemon"
	# Offline everything first. May be needed if we're rebooting, but
	# expect the initiators to reconnect cleanly when we boot again
	# (i.e. we don't want them to reconnect to a tgtd which is still
	# working, but the target is gone).
	tgtadm --op update --mode sys --name State -v offline &>/dev/null
	RETVAL=$?
	if [ "$RETVAL" -eq 107 ] ; then
	    echo "tgtd is not running"
	    [ "$TASK" != "restart" ] && exit 1
	else
	    #tgt-admin --offline ALL
	    # Remove all targets, even if they are still in use.
	    #tgt-admin --update ALL -c /dev/null -f
	    # It will shut down tgtd only after all targets were removed.
	    tgtadm --op delete --mode system
            killall -9 tgtd
	    RETVAL=$?
	    if [ "$RETVAL" -ne 0 ] ; then
		echo "Failed to shutdown tgtd"
		exit 1
	    fi
	fi
	echo -n
}

reload()
{
	echo "Updating target framework daemon configuration"
	# Update configuration for targets. Only targets which
	# are not in use will be updated.
	#tgt-admin --update ALL -c $TGTD_CONFIG &>/dev/null
	RETVAL=$?
	if [ "$RETVAL" -eq 107 ] ; then
	    echo "tgtd is not running"
	    exit 1
	fi
}

forcedreload()
{
	echo "Force-updating target framework daemon configuration"
	# Update configuration for targets, even those in use.
	#tgt-admin --update ALL -f -c $TGTD_CONFIG &>/dev/null
	RETVAL=$?
	if [ "$RETVAL" -eq 107 ] ; then
	    echo "tgtd is not running"
	    exit 1
	fi
}

status()
{
	tgtadm --lld iscsi --mode target --op show
	tgtadm --lld iscsi --mode target --op show --tid 1
}

case $1 in
	start)
		start
		;;
	stop)
		stop
		;;
	forcedstop)
		forcedstop
		;;
	restart)
		TASK=restart
		stop && start
		;;
	forcedrestart)
		TASK=restart
		forcedstop && start
		;;
	reload)
		reload
		;;
	forcedreload)
		forcedreload
		;;
	status)
		status
		;;
	*)
		echo "Usage: $0 {start|stop|forcedstop|restart|forcedrestart|reload|forcedreload|status}"
		exit 2
		;;
esac

