#!/bin/sh

UpgradeDir="/tmpmnt/upgrade"
TarFile="firm.tar.gz"
VersionFile="ImageInfo"
FileList="ugfiles"
ErrorOut="/tmp/upgrade.error.out"
LocalFile="/etc/ImageInfo"
## TmpUgDir="/tmp/upgrade"


cd $UpgradeDir 

tar -zxf $TarFile
if [ $? != 0] ;then
  cd ../..
  umount /tmpmnt
	exit 1
fi

sync
sync

if [ ! -f $VersionFile ]; then
  cd ../..
	umount /tmpmnt
  exit 2
fi

. $LocalFile

Vendor_local=$VendorID ;
echo "vendorid_local = $Vendor_local" > $ErrorOut ;
Product_local=$ProductID ;
echo "product_local = $Product_local" >> $ErrorOut ;
Version_local=$UpgradeVersion ;
echo "version_local = $Version_local" >> $ErrorOut ;
Extra_local=$ExtraVersion ;
echo "extra_local = $Extra_local" >> $ErrorOut ;

. $UpgradeDir/$VersionFile

## mkdir $TmpUgDir

for file in $UpgradeImages;
do	
	if [ ! -f $file ]; then
		echo "Error: The file:$file is not exist in current Image." > $ErrorOut
    cd ../..
		umount /tmpmnt
		exit 3
	fi
##	echo $file >> $TmpUgDir/$FileList
    echo $file >> $FileList
##	cp $file $TmpUgDir/. 
done

Vendor_now=$VendorID
echo "vendor_now = $Vendor_now" >> $ErrorOut
Product_now=$ProductID
echo "product_now = $Product_now" >> $ErrorOut
Version_now=$UpgradeVersion
echo "version_now = $Version_now" >> $ErrorOut
Extra_now=$ExtraVersion
echo "extra_now = $Extra_now" >> $ErrorOut

if [ $Vendor_local != $Vendor_now ]; then
	echo "Error:The VendorID is wrong." >> $ErrorOut
	exit 4
fi

if [ $Product_local != $Product_now ]; then
	echo "Error:The ProductID is wrong." >> $ErrorOut
	exit 5
fi

if [ $Version_now -lt $Version_local ]; then
	echo "Error:The UpgradeVersion is not new." >> $ErrorOut
	exit 6
fi

if [ $Extra_local != $Extra_now ]; then
	echo "Error:The ExtraVersion is wrong." >> $ErrorOut
	exit 7
fi

exit 0
