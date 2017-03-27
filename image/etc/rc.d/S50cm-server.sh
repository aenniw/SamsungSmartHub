#!/bin/sh

CMSERVERD_FLAGS="4567 /etc/cm-server/"
CMSERVERD=/usr/bin/cm-server

case "$1" in
start)
    if [ -x "$CMSERVERD" ] ; then
        echo "start cm-server"
        ${CMSERVERD} ${CMSERVERD_FLAGS} &
    fi
    ;;

stop)
    echo "stop cm-server"
    killall -q cm-server
    ;;

restart)
    $0 stop
    $0 start
    ;;

*)
    echo "usage: $0 { start | stop | restart }" >&2
    exit 1
    ;;

esac
