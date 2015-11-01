#!/bin/sh

IDE_DIR="/proc/ide"
INFO_FILE="/tmp/disk.info"

cd $IDE_DIR

ls | grep hd > $INFO_FILE