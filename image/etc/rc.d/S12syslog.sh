#!/bin/sh
#
# S12syslog.sh - startup script for syslogd
#
# This goes in /usr/storlink/etc/rc.d and gets run at boot-time.

SYSLOGD_FLAGS="-s100 -b2"
SYSLOGD=/sbin/syslogd
##CONF=/etc/thttpd.conf

case "$1" in

start)
    if [ -x "$SYSLOGD" ] ; then
        if [ ! -L /dev/log ]; then
            # might complain for r/o root f/s
            ln -sf /var/run/log /dev/log
        fi
        rm -f /var/run/log
        echo "start syslogd"
        ${SYSLOGD} ${SYSLOGD_FLAGS}
    fi
    ;;

stop)
    echo "stop syslogd"
    ##kill -USR1 `cat /var/run/crond.pid`
    killall -q syslogd
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
