#!/bin/sh
#
#
# 19-Nov-04 amo Try simplified linuxrc
#
#
#
PATH="/sbin:/bin:/usr/sbin:/usr/bin"
#
#
echo ""
echo "Repair the whole system..." 

boot_device=/dev/hdc1
boot1_device=/dev/hdd1
system_device=/dev/md0
data_device=/dev/md1
swap_device=/dev/hdc4
swap_device1=/dev/hdd4

echo "Create partition table at /tmp/patb..."
echo '0,512,83' > /tmp/ptab
echo ',1000,fd' >> /tmp/ptab
echo ',-512,fd' >> /tmp/ptab
echo ',,82'     >> /tmp/ptab

sfdisk -L -uM /dev/hdc < /tmp/ptab
sfdisk -L -uM /dev/hdd < /tmp/ptab

mkswap $swap_device
mkswap $swap_device1
swapon $swap_device
swapon $swap_device1

echo "Create system device and data device..."
mdadm --create --assume-clean --verbose $system_device -n2 -l1 /dev/hdc2 /dev/hdd2
mdadm --create --assume-clean --verbose $data_device -n2 -l1 /dev/hdc3 /dev/hdd3

mke2fs $boot_device
mke2fs $boot1_device
mke2fs -j /dev/md0
mkntfs -f /dev/md1

echo "Get zImage, rd.gz and root.bz2 from PC..."
bootp_server_ip=""
bootpc > bootpc.log
bootp_server_ip=`eval "grep SERVER bootpc.log" | awk '{print $2}'`
echo bootp_server_ip=$bootp_server_ip
our_ip=`eval "grep IPADDR bootpc.log" | awk '{print $2}'`
echo our_ip=$our_ip
ifconfig eth0 $our_ip
mkdir /boot
mount $boot_device /boot
echo "tftp -g -l /boot/zImage   -r zImage  $bootp_server_ip"
tftp -g -l /boot/zImage   -r zImage   $bootp_server_ip
echo "tftp -g -l /boot/rd.gz    -r rd.gz    $bootp_server_ip"
tftp -g -l /boot/rd.gz    -r rd.gz    $bootp_server_ip
echo "tftp -g -l /boot/root.bz2 -r root.bz2 $bootp_server_ip"
tftp -g -l /boot/root.bz2 -r root.bz2 $bootp_server_ip

mkdir /boot1 
mount $boot1_device /boot1
cd /boot1
cp -af /boot/* .

touch /boot1/.newroot
touch /boot/.newroot

echo "Finish repairing whole system."
