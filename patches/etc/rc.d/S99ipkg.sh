#!/bin/sh

case "$1" in
start)
    if [ ! -d "/opt" ]; then mkdir /opt ; fi;
    LOOP_IPKG="NONE";
    for PATH_ in /mnt/*/.*
    do
        if [ "${PATH_#/*/*/}" = ".loopipkg" ]; then
            LOOP_IPKG=$PATH_;
        fi;
    done;

    if [ $LOOP_IPKG = "NONE" ]; then
        for VOLUME in /mnt/*/*/.*
        do
            if [ "${VOLUME#/*/*/*/}" = ".loopipkg" ]; then
                LOOP_IPKG=$VOLUME;
            fi;
        done;
    fi;

    if [ ${LOOP_IPKG} = "NONE" ]; then
        sleep 4 && $0 start &
        exit 1
    fi
    echo "Mounting ipkg image."
    mount -o loop ${LOOP_IPKG} /opt
    if [ -d /opt/etc/init.d ]; then
        echo "Launching Optware initialization scripts"
        for s in /opt/etc/init.d/S* ; do
            [ -x ${s} ] && ${s} start
        done
    else
        echo "error: /opt/etc/ini.d directory not found" >&2
        exit 1
    fi
    ;;
stop)
    kill $(ps -A | grep ${0#${0%/*.*}/} | grep -v $$ | awk '{print $1}')
    if [ -d /opt/etc/init.d ]; then
        echo "Launching Optware termination scripts"
        for s in /opt/etc/init.d/* ; do
            [ -x ${s} ] && ${s} stop
        done
        umount /opt
    else
        echo "error: /opt/etc/init.d directory not found" >&2
        exit 1
    fi
    ;;
*)
    echo $"Usage: $0 {start|stop}"
    exit 1
;;
esac

exit 0;
