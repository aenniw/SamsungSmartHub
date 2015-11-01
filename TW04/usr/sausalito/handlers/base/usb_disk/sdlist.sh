#!/bin/sh

BUS_TYPE=$1
INFO_FILE="/tmp/usb.info"

##vivian, 11/18/2005, for linux 2.6
uname -r | grep "2.6"
if [ $? = 0 ]; then
	USB_DIR="/proc/scsi/scsi"
	cat $USB_DIR | grep $BUS_TYPE > $INFO_FILE
else
	IDE_DIR="/proc/scsi"
	cd $IDE_DIR
	ls | grep usb-storage- > $INFO_FILE
fi