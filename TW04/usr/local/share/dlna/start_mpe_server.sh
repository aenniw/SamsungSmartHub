#!/bin/sh

BASE_DIR=$(pwd)
export LD_LIBRARY_PATH=$BASE_DIR/ffmpeg_libs:$LD_LIBRARY_PATH
echo ""
echo "Set LD_LIBRARY_PATH to \""$LD_LIBRARY_PATH"\""
echo ""
./mpe_server -d