#!/bin/sh

  inip=`/sbin/ifconfig ra0 | grep inet | awk '{printf("%s\n", substr($2,6)) } '`

  if [ "$inip" = "" ] ; then
    inip=`ifconfig br0  | sed -n 's/.*addr:\(.*\) ..*Bcast.*/\1/gp'`
  fi

  if [ "${inip}" = "" ]; then
	echo "Please set eth0 IP address."
	echo "Ex. ifconfig eth0 192.168.2.10"
	exit
  fi

  outip=`ifconfig eth0 | sed -n 's/.*addr:\(.*\) Bcast.*/\1/gp'`

  if [ -z "$outip" ] ; then
	outip="192.168.1.200"
  fi

if [ "start" = "$1" ]; then
  
  /usr/sbin/pppoe-start
  /usr/sbin/pppoe-status | grep P-t-P
  
  if [ "$?" = "1" ]; then
	killall pppd
	killall pppoe-connect
	exit
  fi

  # clear default gateway Rule

  echo "clear default gateway Rule...."
  
  gateway=`/usr/sbin/pppoe-status | sed -n 's/.*P-t-P:\(.*\) ..*Mask.*/\1/gp'`
  outip=`ifconfig ppp0 | sed -n 's/.*addr:\(.*\) ..*P-t-P.*/\1/gp'`
  netmask=`/usr/sbin/pppoe-status | sed -n 's/.*Mask:\(.*\)/\1/gp'`

  /sbin/route del -net 0.0.0.0 netmask 0.0.0.0
  /sbin/route add default gw $gateway

  ## /sbin/iptables -A INPUT -i lo   -j ACCEPT 
	echo "1" > /proc/sys/net/ipv4/ip_forward
	/sbin/iptables -A OUTPUT -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
	/sbin/iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
	/sbin/nat_cfg del eth0
	/sbin/nat_cfg add ip eth0 ${outip} ${netmask}
	/sbin/nat_cfg set enable


	dns=`awk -v ORS=' ' '/nameserver/ { print $2;}' /etc/resolv.conf`

	if [ "$dns" != "" ];then
    	dns_para="&"
	    for i in $dns ; do
			dns_para=$dns_para$i"&"
			echo $dns_para
			echo adding dns $i
		done
		/usr/sausalito/bin/netcfg_to_db dns="$dns_para" &
	fi

  echo "OK! NAT and PPPOE success  ^_^"	

elif [ "stop" = "$1" ]; then

	/usr/sbin/pppoe-stop
	/sbin/nat_cfg set disable
	/usr/bin/killall pppoe-connect

elif [ "restart" = "$1" ]; then
	$0 stop
	$0 start
fi
