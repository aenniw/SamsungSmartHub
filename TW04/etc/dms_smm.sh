#!/bin/sh
#
# dms_smm.sh - startup script for dms_smm 
#

DMS_SMM_ROOT_DIR=/usr/local/share/dlna
DMS_SMM=$DMS_SMM_ROOT_DIR/dms_smm
DMS_SMM_DATA_DIR=$DMS_SMM_ROOT_DIR/DMS/data
DMS_SMM_XML_DIR=$DMS_SMM_ROOT_DIR/xml
MPE_SERVER_ROOT_DIR=$DMS_SMM_ROOT_DIR
WATCHOUT_RUN_DIR=/tmp/sbd/watchout_run


DMS_SMM_PID=/var/run/dms_smm.pid
MPE_SERVER_PID=/var/run/mpe_server.pid
export LD_LIBRARY_PATH=$MPE_SERVER_ROOT_DIR/ffmpeg_libs:$LD_LIBRARY_PATH

SHARE_DIR=$4

if [ -z $5 ]; then
	thumbnail_m=0
	if [ -f /tmp/sbd/create_thumbnail ]; then
		thumbnail_m=`cat /tmp/sbd/create_thumbnail`
	fi

	if [ $thumbnail_m -eq 1 ]; then
		THUMBNAIL_METHOD=Default_Indexing
	else
		THUMBNAIL_METHOD=Default_Thumbnail
	fi
else
	THUMBNAIL_METHOD=Default_Indexing
fi
echo "Thumbnail method=$THUMBNAIL_METHOD"

cd $DMS_SMM_ROOT_DIR

case "$1" in

start)
	if [ -x "$DMS_SMM" ] ; then
		pidof mpe_server >/dev/null
		if [ $? -ne 0 ]; then
			echo "start mpe_server"
			$MPE_SERVER_ROOT_DIR/mpe_server -d
			pidof mpe_server > $MPE_SERVER_PID
		else
			echo "mpe_server is already running"

			pidof dms_smm >/dev/null
			if [ $? -ne 0 ]; then
				echo "restart mpe_server"
				killall mpe_server
				$MPE_SERVER_ROOT_DIR/mpe_server -d
				pidof mpe_server > $MPE_SERVER_PID
			fi
		fi

		pidof dms_smm >/dev/null
		if [ $? -ne 0 ]; then
			echo "start DLNA mediaserver"
			$DMS_SMM -d
			#$DMS_SMM & 
			pidof dms_smm | awk {'print $1}' > $DMS_SMM_PID
		else
			echo "dms_smm is already running"
		fi

		echo 1 >$WATCHOUT_RUN_DIR/dms_smm
		echo 1 >$WATCHOUT_RUN_DIR/mpe_server


		###########################################
		#T111115.sg - for DLNA Certification
		#cp -r /mnt/usba/indexing/CertificationTC /usr/local/share/dlna/DMS/data/
		#echo "add;CertificationTC;CertificationTC;central;/mnt/usba/DLNA_content/CertificationTC;" >/tmp/dms_ipc
		###################
	fi
	;;

stop)
	echo "stop DLNA mediaserver"
	killall mpe_server
	rm $MPE_SERVER_PID
	
	pidof dms_smm >/dev/null
	if [ $? -eq 0 ]; then
		pidof dms_smm | awk {'print $1}' > $DMS_SMM_PID
		#kill -9 `cat $DMS_SMM_PID`
		killall -9 dms_smm
		rm $DMS_SMM_PID
	fi
	
	echo 0 >$WATCHOUT_RUN_DIR/dms_smm
	echo 0 >$WATCHOUT_RUN_DIR/mpe_server
	;;
	



restart)
	echo "restart DLNA mediaserver"

	# stop server
	pidof dms_smm >/dev/null
	if [ $? -eq 0 ]; then
		pidof dms_smm | awk {'print $1}' > $DMS_SMM_PID
		kill -9 `cat $DMS_SMM_PID`
		rm $DMS_SMM_PID
	fi
	
	sleep 2
	# start server
	pidof dms_smm >/dev/null
	if [ $? -ne 0 ]; then
		echo "start DLNA mediaserver"
		$DMS_SMM -d
		pidof dms_smm | awk {'print $1}' > $DMS_SMM_PID
	else
		echo "dms_smm is already running"
	fi
	
	echo 1 >$WATCHOUT_RUN_DIR/dms_smm
	echo 1 >$WATCHOUT_RUN_DIR/mpe_server
	;;




clear)
	echo "clear databases"
	rm -Rf $DMS_SMM_DATA_DIR/*
	rm -f $DMS_SMM_XML_DIR/storage_list.xml
	;;

add)
	pidof dms_smm >/dev/null
	if [ $? -eq 0 ]; then
		echo "add sharefolder"

		case "$2" in
		cdrom)
			#rm -rf $DMS_SMM_DATA_DIR/Optical_Disc/.access_conf/indexing.bin
			#rm -rf $DMS_SMM_DATA_DIR/Optical_Disc
			#echo "add;Optical_Disc;Default_Thumbnail;central;$4;" >/tmp/dms_ipc
			echo "add;Optical_Disc;$THUMBNAIL_METHOD;central;$4;" >/tmp/dms_ipc
			;;

		usb_disk)
			#rm -rf $DMS_SMM_DATA_DIR/USB_Storage/.access_conf/indexing.bin
			#echo "add;USB_Storage;Default_Indexing;central;$4;" >/tmp/dms_ipc
			#rm -f /mnt/usbs/.access_conf/indexing.bin
			#echo "add;USB_Storage;Default_Thumbnail;local;$4;" >/tmp/dms_ipc


			### find volumes in multi partitioned disk
			mount_point=`ls -al $SHARE_DIR | awk '{print $11}'`
			volumes=`df | grep "$mount_point" | awk '{print $6}' | sed "s;$mount_point;;"`

			### do add share in each volume
			for volume in $volumes
			do
				volume=`echo $volume | sed "s;/;;"`
				#rm -f $SHARE_DIR/$volume/.access_conf/indexing.bin
				#echo "add;USB_Storage$volume;Default_Thumbnail;local;$SHARE_DIR/$volume;" >/tmp/dms_ipc
				echo "add;USB_Storage$volume;$THUMBNAIL_METHOD;local;$SHARE_DIR/$volume;" >/tmp/dms_ipc
			done

			### single partition
			if [ -z $volume ]; then
				#rm -f $SHARE_DIR/.access_conf/indexing.bin
				#echo "add;USB_Storage;Default_Thumbnail;local;$SHARE_DIR;" >/tmp/dms_ipc
				echo "add;USB_Storage;$THUMBNAIL_METHOD;local;$SHARE_DIR;" >/tmp/dms_ipc
			fi
			;;

		*)
			#rm -f $DMS_SMM_DATA_DIR/$2/.access_conf/indexing.bin
			#echo "add;$2;Default_Thumbnail;local;$4;" >/tmp/dms_ipc
			echo "add;$2;$THUMBNAIL_METHOD;local;$4;" >/tmp/dms_ipc
			;;
		esac
	else
		echo "dms_smm is not running!"
		exit 2
	fi
	;;


clean)
	pidof dms_smm >/dev/null
	if [ $? -eq 1 ]; then
		echo "clean DB; remove .access_conf/"

		case "$2" in
		cdrom)
			rm -rf $DMS_SMM_DATA_DIR/Optical_Disc
			;;
		
		usb_disk)
			### find volumes in multi partitioned disk
			mount_point=`ls -al $SHARE_DIR | awk '{print $11}'`
			volumes=`df | grep "$mount_point" | awk '{print $6}' | sed "s;$mount_point;;"`

			### do clean DB in each volume
			for volume in $volumes
			do
				volume=`echo $volume | sed "s;/;;"`
				if [ -e $SHARE_DIR/$volume/.access_conf ]; then
					rm -rf $SHARE_DIR/$volume/.access_conf
				fi
			done

			### single partition
			if [ -z $volume ]; then
				if [ -e $SHARE_DIR/.access_conf ]; then
					rm -rf $SHARE_DIR/.access_conf
				fi
			fi
			;;

		*)
			echo "no action"
			;;
		esac
	else
		echo "dms_smm is running!"
	fi
	;;

remove)
	pidof dms_smm >/dev/null
	if [ $? -eq 0 ]; then
		echo "remove sharefolder"

		case "$2" in
		cdrom)
			#echo "remove;Optical_Disc;Default_Thumbnail;central;$4;" >/tmp/dms_ipc
			echo "remove;Optical_Disc;$THUMBNAIL_METHOD;central;$4;" >/tmp/dms_ipc
			#rm -rf $DMS_SMM_DATA_DIR/Optical_Disc
			;;
			
		usb_disk)
			#echo "remove;USB_Storage;Default_Thumbnail;local;$4;" >/tmp/dms_ipc
			#echo "remove;USB_Storage;Default_Indexing;central;$4;" >/tmp/dms_ipc
			#rm -f $DMS_SMM_DATA_DIR/USB_Storage/.access_conf/indexing.bin


			### find volumes in multi partitioned disk
			mount_point=`ls -al $SHARE_DIR | awk '{print $11}'`
			volumes=`df | grep "$mount_point" | awk '{print $6}' | sed "s;$mount_point;;"`

			### do remove share in each volume
			#for volume in $volumes
			for volume in Volume1 Volume2 Volume3 Volume4 Volume5 Volume6 Volume7 Volume8
			do
				volume=`echo $volume | sed "s;/;;"`
				#if [ -e $SHARE_DIR/$volume/.access_conf ]; then
				#	rm -f $SHARE_DIR/$volume/.access_conf/indexing.bin
				#fi
				#echo "remove;USB_Storage$volume;Default_Thumbnail;local;$SHARE_DIR/$volume;" >/tmp/dms_ipc
				echo "remove;USB_Storage$volume;$THUMBNAIL_METHOD;local;$SHARE_DIR/$volume;" >/tmp/dms_ipc
			done

			### single partition
			#if [ -e $SHARE_DIR/.access_conf ]; then
			#	rm -f $SHARE_DIR/.access_conf/indexing.bin
			#fi
			#echo "remove;USB_Storage;Default_Thumbnail;local;$SHARE_DIR;" >/tmp/dms_ipc
			echo "remove;USB_Storage;$THUMBNAIL_METHOD;local;$SHARE_DIR;" >/tmp/dms_ipc
			
			;;

		*)
			#echo "remove;$2;Default_Thumbnail;local;$4;" >/tmp/dms_ipc
			echo "remove;$2;$THUMBNAIL_METHOD;local;$4;" >/tmp/dms_ipc
			#rm -f $DMS_SMM_DATA_DIR/$2/.access_conf/indexing.bin
			;;
		esac
	else
		echo "dms_smm is not running!"
	fi
	;;

thumbnail)
	pidof dms_smm >/dev/null
	if [ $? -eq 0 ]; then
		echo "re-create thumbnail"

		case "$2" in
		cdrom)
			echo "add;Optical_Disc;ReCreate_Thumbnail;central;$4;" >/tmp/dms_ipc
			;;

		usb_disk)
			echo "add;USB_Storage;ReCreate_Thumbnail;local;$4;" >/tmp/dms_ipc
			;;

		*)
			echo "add;$2;ReCreate_Thumbnail;local;$4;" >/tmp/dms_ipc
			;;
		esac
	fi
	;;

rescan)
	$0 remove usb_disk 6312 /mnt/usbs
	$0 add usb_disk 6312 /mnt/usbs
	;;

*)
	echo "usage: $0 { start | stop | restart | clear | add | remove | thumbnail }" >&2
	exit 1
	;;

esac
