#!/bin/sh
ifconfig eth1 up
echo "Start PPPOE........Please Wait 10 Sec !!"
pppoe-start

echo "Set Iptables rule......"

echo "1" > /proc/sys/net/ipv4/ip_forward 
iptables -F -t nat 
iptables -X -t nat 
iptables -Z -t nat 
iptables -t nat -P PREROUTING  ACCEPT 
iptables -t nat -P POSTROUTING ACCEPT 
iptables -t nat -P OUTPUT      ACCEPT 
iptables -t nat -A POSTROUTING -o ppp0 -s 192.168.2.0/24 -j MASQUERADE
iptables -A OUTPUT -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

echo "OK! NAT and PPPOE success  ^_^"

