#!/bin/sh
# chkconfig: 2345 55 25
# Description: Startup script for mengshoutang game server. Place in /etc/init.d and
# run 'update-rc.d -f mengshoutang defaults', or use the appropriate command on your
# distro. For CentOS/Redhat run: 'chkconfig --add mengshoutang'

### BEGIN INIT INFO
# Provides:          mengshoutang
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start mengshoutang game server
# Description:       Start mengshoutang game server
### END INIT INFO

# @author Rolong<rolong@vip.qq.com>

SCREEN_NAME=mst01

start() {
    echo "Starting mengshoutang ..."
    if screen -ls | grep $SCREEN_NAME; then
        echo "Screen("$SCREEN_NAME") Running ..."
        echo 3 >> /tmp/mengshoutang.txt
    else
        cd /gamedata1/myserver
        screen -dmS $SCREEN_NAME ./start.sh
        echo "Start "$SCREEN_NAME" OK!"
        echo 3 >> /tmp/mengshoutang.txt
    fi
}

stop() {
    echo "TODO: Stopping ..."
    echo 2 >> /tmp/mengshoutang.txt
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
