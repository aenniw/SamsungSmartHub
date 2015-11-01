#!/bin/sh

IDE_DIR="/proc/scsi"
INFO_FILE="/tmp/usb.info"

cd $IDE_DIR

ls | grep usb-storage- > $INFO_FILE