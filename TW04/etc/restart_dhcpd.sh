#!/bin/sh

killall -9 dhcpd
sleep 1
/sbin/dhcpd -q ra0
