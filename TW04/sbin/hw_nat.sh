#!/bin/sh

  inip=`ifconfig eth0 | sed -n 's/.*addr:\(.*\) ..*Bcast.*/\1/gp'`
  inmask=`ifconfig eth0 | sed -n 's/.*Mask:\(.*\)$/\1/gp'`
  INIF="eth0"  # LAN

  if [ "$inip" = "" ] ; then
    inip=`ifconfig br0  | sed -n 's/.*addr:\(.*\) ..*Bcast.*/\1/gp'`
    inmask=`ifconfig br0 | sed -n 's/.*Mask:\(.*\)$/\1/gp'`
    INIF="br0"  # LAN
  fi

  if [ "${inip}" = "" ]; then
    echo "!!!ERROR NO eth0 IP "
    exit
  fi

  outip=`ifconfig eth1 | sed -n 's/.*addr:\(.*\) ..*Bcast.*/\1/gp'`
  outmask=`ifconfig eth1 | sed -n 's/.*Mask:\(.*\)$/\1/gp'`

  if [ -z "$outip" ] ; then
    echo "!!!ERROR NO eth1 IP "
    exit
  fi
  
  EXTIF="eth1" # WAN

if [ "start" = "$1" ]; then

# localhost and lan can access the server and internet 

  ## /sbin/iptables -A INPUT -i lo   -j ACCEPT 
  if [ "$INIF" != "" ]; then
	echo "Set Software and Hardware Nat Rules...."
	##/sbin/iptables -A INPUT -i $INIF -j ACCEPT 
	echo "1" > /proc/sys/net/ipv4/ip_forward 
	/sbin/iptables -t nat -A POSTROUTING -s ${inip}/${inmask} -o $EXTIF -j MASQUERADE
	/sbin/nat_cfg del eth0
	/sbin/nat_cfg del eth1
	/sbin/nat_cfg add ip eth0 ${inip} ${inmask}
	/sbin/nat_cfg add ip eth1 ${outip} ${outmask}
	/sbin/nat_cfg set eth0 lan
	/sbin/nat_cfg set eth1 wan
	/sbin/nat_cfg set enable
  fi 

echo "OK.....^_^"	

elif [ "stop" = "$1" ]; then
	/sbin/iptables -t nat -D POSTROUTING -s ${inip}/${inmask} -o $EXTIF -j MASQUERADE
	/sbin/nat_cfg del eth0
	/sbin/nat_cfg del eth1	
	/sbin/nat_cfg set disable
elif [ "restart" = "$1" ]; then
	$0 stop
	$0 start
fi
