#!/bin/sh
echo "Config Net interface......"
ifconfig eth0 0.0.0.0
cd /lib/modules
insmod rt2860ap.ko
ifconfig ra0 up
sleep(3)
brctl addbr br0
brctl addif bro eth0
brctl addif br0 ra0 
ifconfig br0 192.168.2.92
ifconfig eth1 192.168.1.200

echo "Set filter rule...."

echo "1" > /proc/sys/net/ipv4/ip_forward 
/sbin/iptables -F -t nat 
/sbin/iptables -X -t nat 
/sbin/iptables -Z -t nat 
/sbin/iptables -t nat -P PREROUTING  ACCEPT 
/sbin/iptables -t nat -P POSTROUTING ACCEPT 
/sbin/iptables -t nat -P OUTPUT      ACCEPT 


/sbin/iptables -t nat -A POSTROUTING -o br0 -s 192.168.2.0/24 -j MASQUERADE

echo "NAT rule OK.........^_^"
#cat /proc/net/ip_conntrack
