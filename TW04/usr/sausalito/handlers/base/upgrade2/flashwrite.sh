#!/bin/sh

FLAG=$1
ISRAID=$2

sh -c '
      sleep 10000
' > /dev/null 2>&1 &
echo BYE SUCCESS

	killall monitor_sam
	killall watchcatd
	killall smartbackupd

	ifconfig ra0 down

##vivian, 11/18/2005, for linux 2.6
    uname -r | grep "2.6"
	if [ $? = 0 ]; then
    		rmmod uhci_hcd
    		rmmod ohci_hcd
    		rmmod ehci_hcd
    		rmmod rt5390ap
		swapoff -a
    	else
    		rmmod usb-uhci
    		rmmod ehci-hcd
    		rmmod rt5390ap
    	fi
	killall nmbd
	killall	rpc.mountd
	killall lpd
	killall portmap
	killall proftpd
	killall mdadm
	killall -9 tgtd
	killall -9 dms_smm
	killall mpe_server

	

	#if [ $FLAG != 1 ]; then
	#	rm -rf /usr/sausalito/codb
	#	cp -af /system/codb /usr/sausalito/
	#fi
	
	sync
	sync
	
	#if [ $ISRAID != 0 ]; then
	#	umount /dev/md1
	#	umount /system
	#	mdadm --stop /dev/md[01]
	#fi
	
	sleep 2
    

	#T111210.sg - f/w update aging
	FWUPDIR=/mnt/usbs/se208bwfwupdir
	echo "Check $FWUPDIR"
	if [ -e $FWUPDIR/aging ]; then
    	if [ -e /usr/bin/fchecksum ]; then
	        echo "!!! F/W update aging mode !!!"
			if [ ! -e $FWUPDIR/result ]; then
				echo "0" > $FWUPDIR/result
			else
				lines=`cat $FWUPDIR/result | sed -n '$='`
				echo `expr $lines / 9` >> $FWUPDIR/result
			fi
			/usr/bin/fchecksum >> $FWUPDIR/result
		fi
	fi
																					
    /usr/sausalito/handlers/base/upgrade2/led_blinking &
    /usr/sausalito/handlers/base/upgrade2/program
	
