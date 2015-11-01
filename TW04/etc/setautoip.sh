#!/bin/sh
# scripts to set the auto-selected IP, called by AVH-IPv4LL
#
if [ $1 = "config" ]; then	
	echo IP=$ip	
	ifconfig eth0 $ip	
	echo $ip > /tmp/.ipaddr
fi
