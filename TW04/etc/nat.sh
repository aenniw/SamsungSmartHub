
#!/bin/sh
#Usage 			./nat.sh ETH0 ETH1
#Default setting	./nat.sh 192.168.2.94 192.168.1.201 Interface 192.168.2.0/24

if [ $# -ne 4 ]; then     
    echo "Syntax Errot: ./nat.sh 192.168.2.X   192.168.1.X Interface 192.168.2.0/24"
    exit
fi

ifconfig eth0 $1
ifconfig eth1 $2

echo "Set Netfilter Rule...."
echo "1" > /proc/sys/net/ipv4/ip_forward 
/sbin/iptables -F -t nat 
/sbin/iptables -X -t nat 
/sbin/iptables -Z -t nat 
/sbin/iptables -t nat -P PREROUTING  ACCEPT 
/sbin/iptables -t nat -P POSTROUTING ACCEPT 
/sbin/iptables -t nat -P OUTPUT      ACCEPT 

/sbin/iptables -t nat -A POSTROUTING -o $3 -s $4 -j MASQUERADE
#/sbin/iptables -t nat -A POSTROUTING -o eth1 -s 192.168.2.0/24 -j MASQUERADE

echo "OK.....^_^"
#cat /proc/net/ip_conntrack
