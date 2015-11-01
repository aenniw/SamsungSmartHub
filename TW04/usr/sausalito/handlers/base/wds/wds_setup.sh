#!/bin/sh


lan_ip=`ifconfig ra0  | sed -n 's/.*addr:\(.*\) ..*Bcast.*/\1/gp'`

ifconfig ra0 down
ifconfig ra0 up

ip route del $lan_ip/24
ip route del default

brctl addbr br0
brctl addif br0 wds0
brctl addif br0 ra0
ifconfig wds0 0.0.0.0
ifconfig ra0 0.0.0.0
ip link set br0 up
ip addr add $lan_ip/24 brd + dev br0
ip route add default via $lan_ip

