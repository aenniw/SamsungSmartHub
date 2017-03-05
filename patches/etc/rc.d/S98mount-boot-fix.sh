#!/bin/sh

case $1 in
-d )
    MOUNTING=`ps | grep "/usr/sausalito/handlers/base/usb_disk/mtPoint.sh" | toybox wc -l`
    if [ ! "$MOUNTING" = "1" ]; then
        sleep 2 && $0 -d &
        exit 0
    fi
    DISKS=`fdisk -l 2>/dev/null | grep "Disk \/" | grep -v "\/dev\/md" | awk '{print $2}' | sed -e 's/://g'`
    MOUNTED_DISKS=`df | grep "dev" |awk '{print $1}' | sed 's/[0-9]//g'`
    for DISK in ${DISKS}; do
        MOUNTED="N/A"
        for MOUNTED_DISK in ${MOUNTED_DISKS}; do
            if [ "$MOUNTED_DISK" = "$DISK" ]; then
                MOUNTED=true
                break
            fi
        done;
        if [ "$MOUNTED" = "N/A" ]; then
            test -d "/mnt/usb${DISK#*/*/sd}" || /usr/sausalito/handlers/base/usb_disk/mtPoint.sh ${DISK} "/mnt/usb${DISK#*/*/sd}"
        fi
    done
    sleep 10 && $0 -d &
    exit 0
;;
* )
    sleep 1 && $0 -d &
    sleep 60 && killall ${0#${0%/*.*}/} &
    exit 0
;;
esac

