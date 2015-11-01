#!/bin/sh

PAR_NAME=$1


sh -c '
      sleep 10000
' > /dev/null 2>&1 &
echo BYE SUCCESS

sync
sync

mkntfs -f $PAR_NAME
if [ $? != 0 ]; then
	echo "Fail" > /tmp/disk.percent
else
  echo "Complete" > /tmp/disk.percent
  killall sleep
fi    	

exit 0