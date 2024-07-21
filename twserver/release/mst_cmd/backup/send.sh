#!/bin/sh
# @author Rolong<rolong@vip.qq.com>

SCRIPT=`basename $0`

SERVER_SVN_DIR=/data/myserver
ADMIN_SVN_DIR=/home/default
RELEASE_TOOLS_DIR=/data/release_tools
TARGET_PACKAGE_DIR=/gamedata1/release_package
TARGET_MYSERVER_DIR=/gamedata1/myserver
TARGET_ADMIN_DIR=/usr/local/nginx/wwwroot
DATE=`date +%Y%m%d%H%M%S`

remote_exe() {
	if [[ ! -n $1 ]]
    then
        echo "[Send] Argument Can NOT Be NULL!"
        exit 0;
    fi
    echo "romote exe: "${1}
    ssh -i ~/.ssh/turbotech_dev_rsa root@10.160.23.182 $1
}

send() {
    if [[ ! -n $2 ]] || [[ ! -n $1 ]]
    then
        echo "[Send] Argument Can NOT Be NULL!"
        exit 0;
    fi
    scp -i ~/.ssh/turbotech_dev_rsa $1 root@10.160.23.182:$2
}

send_server (){
    if [ ! -f $RELEASE_TOOLS_DIR/myserver.tar.gz ]
    then
        echo "myserver.tar.gz not found! "
        exit 0;
    fi

    send $RELEASE_TOOLS_DIR/myserver.tar.gz $TARGET_PACKAGE_DIR
}

send_admin (){
    if [ ! -f $RELEASE_TOOLS_DIR/admin.tar.gz ]
    then
        echo "admin.tar.gz not found! "
        exit 0;
    fi

    send $RELEASE_TOOLS_DIR/admin.tar.gz $TARGET_PACKAGE_DIR
}

send_sql (){
    if [ ! -f $RELEASE_TOOLS_DIR/myserver.sql ]
    then
        echo "myserver.sql not found! "
        exit 0;
    fi

    send $RELEASE_TOOLS_DIR/myserver.sql $TARGET_PACKAGE_DIR
}

send_server_file() {
    if [[ ! -n $1 ]]
    then
        echo "[send_server_file] Argument Can NOT Be NULL!"
        exit 0;
    fi

    FILE=$SERVER_SVN_DIR/$1

    if [ ! -f $FILE ]
    then
        echo "File Not Found: "$FILE
        exit 0;
    fi

    TARGET_FILE=$TARGET_MYSERVER_DIR/$1
    BASE_NAME=`basename ${1}`
    remote_exe "cp "${TARGET_FILE}" "${TARGET_PACKAGE_DIR}"/server_src_update_backup/"${DATE}"_"$BASE_NAME

    send $FILE $TARGET_MYSERVER_DIR/$1
}

send_admin_file() {

	if [[ ! -n $1 ]]
	then
		echo "[send_admin_file] Argument Can NOT Be NULL!"
		exit 0;
	fi

    FILE=$ADMIN_SVN_DIR/$1

    if [ ! -f $FILE ]
    then
        echo "File Not Found: "$FILE
        exit 0;
    fi

    TARGET_FILE=$TARGET_ADMIN_DIR/$1
    BASE_NAME=`basename ${1}`
    BACK_FILE=${TARGET_PACKAGE_DIR}"/admin_src_update_backup/"${DATE}"_"$BASE_NAME
    remote_exe "cp "${TARGET_FILE}" "$BACK_FILE

    send $FILE $TARGET_ADMIN_DIR/$1
}

case "$1" in
    all)
        send_server
        send_admin
        send_sql
        ;;
    server_file)
        send_server_file $2 
        ;;
    admin_file)
        send_admin_file $2 
        ;;
    send)
	    send $2 $3
	    ;;
    remote_exe)
	    remote_exe $2
	    ;;

    *)
        echo "Usage: [all | send SRC DST | server_file SRC | admin_file SRC]"
        exit 0
        ;;
esac

wait
echo "-------------------------------------------"
echo " $SCRIPT ${1} ${2} ok!"
echo "-------------------------------------------"

# ex: ts=4 sw=4 et
# vim: set foldmethod=marker foldmarker=##',##.:
