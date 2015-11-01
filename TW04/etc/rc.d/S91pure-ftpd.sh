#!/bin/sh
ftp_enable="NO"
. /etc/rc.conf

case $ftp_enable in
[Yy][Ee][Ss])
      ;;
[Nn][Oo])
      return 0
      ;;
*)
      echo "Please set ftp_enable=\"Yes\" in /etc/rc.conf to start ftp service"
      ;;
esac

pureftpd="/usr/sbin/pure-ftpd -lpuredb:/etc/pureftpd.pdb -B -E -u1 -A"

if [ "start" = "$1" ]; then
	${pureftpd}
elif [ "stop" = "$1" ]; then
	killall pure-ftpd
elif [ "restart" = "$1" ]; then
	kill -HUP `pidof pure-ftpd` 
fi
