#!/bin/sh

if [ -e /mnt/usbs/se208bwfwupdir/aging ]; then
	echo "### F/W UPDATE AGING MODE ###"
	if [ -e /mnt/usbs/se208bwfwupdir/208bwfw.tar.gz ]; then
		echo "### NOW F/W UPDATING... ###"
		mount -t tmpfs tmpfs /tmpmnt -o size=32m
		mkdir /tmpmnt/upgrade
		ln -s /mnt/usbs/se208bwfwupdir/208bwfw.tar.gz /tmpmnt/upgrade/firm.tar.gz
		/usr/sausalito/handlers/base/upgrade2/CheckImage.sh
		/usr/sausalito/handlers/base/upgrade2/flashwrite.sh &
	else
		echo "### CANNOT FIND UPDATE FILE(/mnt/usbs/se208bwfwupdir/208bwfw.tar.gz) ###"
	fi
fi
