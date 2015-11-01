#!/bin/sh

# create thumbnail - ODD
/etc/dms_smm.sh remove cdrom 6311 /mnt/cdrom
/etc/dms_smm.sh thumbnail cdrom 6311 /mnt/cdrom

# create thumbnail - USBS 
/etc/dms_smm.sh remove usb_disk 6312 /mnt/usbs
/etc/dms_smm.sh thumbnail usb_disk 6312 /mnt/usbs

