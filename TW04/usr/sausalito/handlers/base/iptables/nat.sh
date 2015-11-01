#!/bin/sh

  inip=`ifconfig ra0 | sed -n 's/.*addr:\(.*\) ..*Bcast.*/\1/gp'`
  inmask=`ifconfig ra0 | sed -n 's/.*Mask:\(.*\)$/\1/gp'`
  INIF="ra0"  # LAN

 # if [ "$inip" = "" ] ; then
 #   inip=`ifconfig br0  | sed -n 's/.*addr:\(.*\) ..*Bcast.*/\1/gp'`
 #   inmask=`ifconfig br0 | sed -n 's/.*Mask:\(.*\)$/\1/gp'`
 #   INIF="br0"  # LAN
 # fi

  if [ "${inip}" = "" ]; then
        echo "Please set eth0 IP address."
        echo "Ex. ifconfig eth0 192.168.2.10"
        exit
  fi

  ##outip=`ifconfig eth1 | sed -n 's/.*addr:\(.*\) Bcast.*/\1/gp'`

  ##if [ -z "$outip" ] ; then
  ##outip="192.168.1.200"
  ##fi
  
  if [ "$2" = "" ];then
     EXTIF="eth0" # WAN
  else
     EXTIF="$2"
  fi

if [ "start" = "$3" ]; then

# localhost and lan can access the server and internet 

  ## /sbin/iptables -A INPUT -i lo   -j ACCEPT 
  if [ "$INIF" != "" ]; then
	echo "Set Nat Rule...."
	##/sbin/iptables -A INPUT -i $INIF -j ACCEPT 
	echo "1" > /proc/sys/net/ipv4/ip_forward 

  #delete previous MASQ rules	
	/sbin/iptables -t nat -D POSTROUTING -s ${inip}/${inmask} -o $EXTIF -j MASQUERADE
	/sbin/iptables -t nat -D POSTROUTING -s ${inip}/${inmask} -o ppp0  -j MASQUERADE	
	
	/sbin/iptables -t nat -A POSTROUTING -s ${inip}/${inmask} -o $EXTIF -j MASQUERADE
	/sbin/iptables -t nat -A POSTROUTING -s ${inip}/${inmask} -o ppp0  -j MASQUERADE
	/sbin/nat_cfg set enable
  fi 

echo "OK.....^_^"	

elif [ "stop" = "$3" ]; then
	/sbin/iptables -t nat -D POSTROUTING -s ${inip}/${inmask} -o $EXTIF -j MASQUERADE
	/sbin/iptables -t nat -D POSTROUTING -s ${inip}/${inmask} -o ppp0  -j MASQUERADE
	/sbin/nat_cfg set disable
elif [ "restart" = "$3" ]; then
	$0 $1 $2 stop
	$0 $1 $2 start
fi
