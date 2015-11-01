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

ifconfig eth0 192.168.1.1
route add default gw 192.168.1.1

boot_device=/dev/sda1
boot1_device=/dev/sdb1
system_device=/dev/md0
data_device=/dev/md1
swap_device=/dev/sda4
swap_device1=/dev/sdb4

/sbin/recovery 1

echo "Create partition table at /tmp/patb..."
echo '0,512,83' > /tmp/ptab
echo ',1000,fd' >> /tmp/ptab
echo ',-512,fd' >> /tmp/ptab
echo ',,82'     >> /tmp/ptab

sfdisk -L -uM /dev/sda < /tmp/ptab
sfdisk -L -uM /dev/sdb < /tmp/ptab

mkswap $swap_device
mkswap $swap_device1
swapon $swap_device
swapon $swap_device1

/sbin/recovery 2

echo "Create system device and data device..."
mdadm --stop /dev/md0
mdadm --zero-superblock /dev/sd[ab]2
mdadm --stop /dev/md1
mdadm --zero-superblock /dev/sd[ab]3
mdadm --create --assume-clean --run --verbose $system_device -n2 -l1 /dev/sda2 /dev/sdb2
mdadm --create --assume-clean --run --verbose $data_device -n2 -l1 /dev/sda3 /dev/sdb3

mke2fs $boot_device
mke2fs $boot1_device
mke2fs -j /dev/md0
mkntfs -f /dev/md1

/sbin/recovery 3

echo "Get zImage, rd.gz and root.bz2 from PC..."
##ifconfig eth0 192.168.1.1
##route add default gw 192.168.1.1
##bootpc > bootpc.log
our_ip=`eval "grep IPADDR bootpc.log" | awk '{print $2}'`
echo our_ip=$our_ip
bootp_server_ip=`eval "grep SERVER bootpc.log" | awk '{print $2}'`              
echo bootp_server_ip=$bootp_server_ip   
ifconfig eth0 $our_ip
mkdir /boot
mount $boot_device /boot
echo "tftp -g -l /boot/zImage   -r zImage   $bootp_server_ip"
tftp -g -l /boot/zImage   -r zImage   $bootp_server_ip
echo "tftp -g -l /boot/rd.gz    -r rd.gz    $bootp_server_ip"
tftp -g -l /boot/rd.gz    -r rd.gz    $bootp_server_ip
echo "tftp -g -l /boot/root.bz2 -r root.bz2 $bootp_server_ip"
tftp -g -l /boot/root.bz2 -r root.bz2 $bootp_server_ip

mkdir /boot1
mount $boot1_device /boot1
cd /boot1
cp -af /boot/* .

touch /boot/.newroot
touch /boot1/.newroot

cd /
sync
sync
umount /boot
umount /boot1

route add default gw $our_ip

/sbin/recovery 4 $our_ip
/sbin/recovery 5 
/sbin/recovery 6 

echo "Finish repairing whole system."
