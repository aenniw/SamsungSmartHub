#!/bin/sh

SAVE_DIR="/tmpmnt/configuration"
SAVE_FILE_NAME="config.tar"
VersionFile="ImageInfo"

cd $SAVE_DIR

## Untar configuration file 
tar -xf $SAVE_FILE_NAME
if [ $? != 0 ]; then
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

exit 0