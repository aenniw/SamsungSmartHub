#!/bin/sh

echo "Config Net interface......"
ifconfig eth0 down
ifconfig eth1 down
ifconfig eth0 192.168.1.200
ifconfig eth1 192.168.3.200
ifconfig eth1:1 192.168.2.100

echo "Set filter rule...."

echo "1" > /proc/sys/net/ipv4/ip_forward 
/sbin/iptables -F -t nat 
/sbin/iptables -X -t nat 
/sbin/iptables -Z -t nat 
/sbin/iptables -t nat -P PREROUTING  ACCEPT 
/sbin/iptables -t nat -P POSTROUTING ACCEPT 
/sbin/iptables -t nat -P OUTPUT      ACCEPT 


/sbin/iptables -t nat -A POSTROUTING -o eth1 -s 192.168.1.0/24 -j MASQUERADE

echo "NAT rule OK.........^_^"
#cat /proc/net/ip_conntrack

iptables -t nat -A PREROUTING -d 192.168.2.100 -i eth1 -p tcp --dport 80 -j DNAT --to-destination 192.168.1.1:80
iptables -t nat -A PREROUTING -d 192.168.3.200 -i eth1 -p tcp --dport 8080 -j DNAT --to-destination 192.168.1.2:8080

