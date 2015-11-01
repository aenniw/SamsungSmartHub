#!/bin/sh

for dir in ${1%/}/*
do
	if [ ! -d $dir ]; then
		continue;
	fi
	DIR=`echo $dir | awk '{print toupper($0)}'`
	case "${DIR#/*/*/}" in
	"FILMY" | "MOVIES")
		test -d /media/Filmy/ || mkdir /media/Filmy/
		chmod 777 /media/Filmy/
		ln -s $dir/* /media/Filmy/
	  ;;
	"SERIALY")
		test -d /media/Serialy/ || mkdir /media/Serialy/
		chmod 777 /media/Serialy/
		ln -s $dir/* /media/Serialy/
	  ;;
	"HUDBA" | "MP3" | "MUSIC")
		test -d /media/Hudba/ || mkdir /media/Hudba/
		chmod 777 /media/Hudba/
		ln -s $dir/* /media/Hudba/
	  ;;
	"FOTOGRAFIE" | "PHOTOS")
		test -d /media/Fotografie/ || mkdir /media/Fotografie/
		chmod 777 /media/Fotografie/
		ln -s $dir/* /media/Fotografie/
	  ;;
        "NOVE" | "NEW" | "STIAHNUTE"| "DOWNLOADED")
                test -d /media/Stiahnute/ || mkdir /media/Stiahnute/
		chmod 777 /media/Stiahnute/
                ln -s $dir/* /media/Stiahnute/
          ;;
	*)
		echo "Unknown Dir";
	  ;;
	esac
done

DISK=${1#/*/.}
DISK=${DISK%*/*}
DISK=`echo $DISK | awk '{print toupper($0)}'`

echo "[$DISK]" >>/etc/samba/smb.conf;
echo "  comment = USB storage" >>/etc/samba/smb.conf;
echo "  #read only = yes" >>/etc/samba/smb.conf;
echo "  locking = no" >>/etc/samba/smb.conf;
echo "  path = $1" >>/etc/samba/smb.conf;
echo "  guest ok = no" >>/etc/samba/smb.conf;
echo "  #guest ok = yes" >>/etc/samba/smb.conf;
echo "  create mask = 0777" >>/etc/samba/smb.conf;
echo "  directory mask = 0775" >>/etc/samba/smb.conf;
echo "  writable = yes" >>/etc/samba/smb.conf;
echo "  use sendfile = yes" >>/etc/samba/smb.conf;
echo "  write list = admin, smarthub" >>/etc/samba/smb.conf;

#restart samba
/etc/rc.d/S80samba.sh restart &
