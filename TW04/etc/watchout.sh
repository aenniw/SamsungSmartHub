#!/bin/sh

PROCESS=$1
SCRIPT=$2

# Get the watchout_run value
watchout_run=0
watchout_run=`cat /tmp/sbd/watchout_run/$PROCESS`

# Start the process if the process is not running while watchout_run value is 1
if [ $watchout_run -eq 1 ]; then
	pidof $PROCESS >/dev/null
	if [ $? -ne 0 ]; then
		echo "$PROCESS is unexpectedly dead. start again!"
		$SCRIPT start
	fi
fi


