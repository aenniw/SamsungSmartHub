#!/bin/sh
#
# Script to restart DLNA Server
#
#

echo "DLNA Server Restart"

rm -f /usr/local/share/dlna/xml/storage_list.xml
rm -Rf /usr/local/share/dlna/DMS/data/*
DMS_SMM_PID=`pidof dms_smm | awk '{print $1'}`
kill ${DMS_SMM_PID}

echo "success" > /tmp/restart.txt
