#!/bin/sh

## There are 3 steps
## 1. Make /volume1/configuration directory
## 2. copy /usr/sausalito/codb & /usr/hddapp/etc(Not include rc.d) directory
## 3. backup to config.tar.gz & copy to /usr/webroot


#CODB_DIR="/system/codb"
CODB_DIR="/usr/sausalito/codb"
VersionFile="/etc/ImageInfo"
SAVE_DIR="/tmp/configuration"
SAVE_FILE_NAME="config.tar"
WEB_DIR="/usr/webroot"

#### Build the /volume1/configuration backup folder
## Clean /volume1/configuration
rm -rf $SAVE_DIR

## Make /volume1/configuration directory
mkdir -p $SAVE_DIR
####

#### Backup the data
## copy /etc/ImageInfo to /volume1/configuration
cp $VersionFile $SAVE_DIR/.

## copy /usr/sausalito/codb to /volume1/configuration/codb
cp -a $CODB_DIR $SAVE_DIR/.


#### tar to config.tar
cd $SAVE_DIR
tar -cf $SAVE_DIR/$SAVE_FILE_NAME *

cp -a $SAVE_DIR/$SAVE_FILE_NAME $WEB_DIR/$SAVE_FILE_NAME

sync
sync
