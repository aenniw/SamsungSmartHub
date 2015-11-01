#!/bin/sh

if [ $# -ne 3 ]; then
	echo "Syntax Errot: ./pppoe.sh 192.168.2.X   192.168.1.X  192.168.2.0/24 "
	exit
fi

ifconfig eth1 up
echo "Start PPPOE........Please Wait 10 Sec !!"
cd /usr/sbin/
pppoe-start

ifconfig eth0 $1
ifconfig eth1 $2

echo "Set Iptables rule......"

echo "1" > /proc/sys/net/ipv4/ip_forward 
/sbin/iptables -F -t nat 
/sbin/iptables -X -t nat 
/sbin/iptables -Z -t nat 
/sbin/iptables -t nat -P PREROUTING  ACCEPT 
/sbin/iptables -t nat -P POSTROUTING ACCEPT 
/sbin/iptables -t nat -P OUTPUT      ACCEPT 
/sbin/iptables -t nat -A POSTROUTING -o ppp0 -s $3 -j MASQUERADE
#/sbin/iptables -t nat -A POSTROUTING -o ppp0 -s 192.168.2.0/24 -j MASQUERADE
/sbin/iptables -A OUTPUT -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
/sbin/iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

echo "OK! NAT and PPPOE success  ^_^"

