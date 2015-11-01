# Mounted target
MOUNT_TARGET=`ls /mnt/usbs -l | awk '{print $11}'`
NUM_PART=`cat /proc/partitions | grep 'sd' | sed -n '$='`
USBS_USAGE_FILE=/tmp/sbd/usbs_usage.raw


if [ ! -z $MOUNT_TARGET ]; then
	Total_list=`df | grep $MOUNT_TARGET | awk '{print $2}'`
	Avail_list=`df | grep $MOUNT_TARGET | awk '{print $4}'`
	FS_list=`mount | grep $MOUNT_TARGET | awk '{print $5}'`


	# The number of volumes
	cnt=0
	for total in $Total_list
	do
		cnt=`expr $cnt + 1`
	done
	echo "$cnt" > $USBS_USAGE_FILE

	

	cnt=0
	for total in $Total_list
	do
		cnt=`expr $cnt + 1`

		# Avail Capacity
		cnt2=0
		for avail in $Avail_list
		do
			cnt2=`expr $cnt2 + 1`
			if [ $cnt -eq $cnt2 ]; then
				break;
			fi
		done

		# Mounted Filesystem
		cnt2=0
                for fs in $FS_list
                do
                        cnt2=`expr $cnt2 + 1`
                        if [ $cnt -eq $cnt2 ]; then
                                break;
                        fi
                done

				echo "$avail/$total" >> $USBS_USAGE_FILE
				
                total=`expr $total / 1024`
                avail=`expr $avail / 1024`

                if [ `expr $fs == "vfat"` -eq 1 ]; then
                        fs="FAT32"
                elif [ `expr $fs == "ufsd"` -eq 1 ]; then
                        fs="NTFS"
                fi

                if [ $NUM_PART -eq 1 ]; then
                        echo $avail / $total MB "($fs)"
                elif [ $NUM_PART -eq 2 ]; then
                        echo $avail / $total MB "($fs)"
                else
                        echo "[Volume$cnt]: " $avail / $total MB "($fs)"
                fi
	done
fi
