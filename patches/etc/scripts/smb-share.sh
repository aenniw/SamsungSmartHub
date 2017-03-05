#!/bin/sh

DISK=${2#/*/.}
DISK=${DISK%*/*}
DISK=`echo ${DISK} | awk '{print toupper($0)}'`

SAMBA_CNF="/etc/samba/smb.conf"
SAMBA_SHARE="[$DISK]
comment = USB storage
locking = no
path = $2
guest ok = no
create mask = 0777
directory mask = 0775
writable = yes
use sendfile = yes
write list = admin, smarthub"

case $1 in
"-a" | "--add" )
    grep -Fq "[$DISK]" ${SAMBA_CNF}
    if [ $? -ne 0 ];then
        echo "${SAMBA_SHARE}\n\n" >> ${SAMBA_CNF}
        /etc/rc.d/S80samba.sh restart
    fi
  ;;
"-r" | "--remove" )
    grep -Fq "[$DISK]" ${SAMBA_CNF}
    if [ $? -eq 0 ];then
        sed -ie "/\[$DISK\]/,+12d" ${SAMBA_CNF}
        /etc/rc.d/S80samba.sh restart
    fi
  ;;
* )
    echo "Usage:: options PATH
            -a --add        -- adds new share
            -r --remove     -- removes used share
         "
  ;;
esac