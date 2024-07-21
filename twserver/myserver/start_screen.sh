#!/bin/sh
# @author Rolong<rolong@vip.qq.com>

SCREEN_NAME=dev

start() {
    echo "Starting mengshoutang ..."
    if screen -ls | grep $SCREEN_NAME; then
        echo "Screen("$SCREEN_NAME") Running ..."
    else
        cd /home/mst_server
        screen -dmS $SCREEN_NAME ./start.sh
        if screen -ls | grep $SCREEN_NAME; then
            echo "Start screen("$SCREEN_NAME") OK!"
        else
            echo "Start screen("$SCREEN_NAME") FAIL!"
        fi
    fi
}

stop() {
    echo "TODO: Stopping ..."
}

# See how we were called.
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart|force-reload)
        stop
        start
        ;;
    *)
        start
        ;;
esac
