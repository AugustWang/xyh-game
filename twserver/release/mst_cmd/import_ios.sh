#!/bin/sh
# @author Rolong<rolong@vip.qq.com>

ERROR_RREFIX="[ERROR] "
ADMIN_DIR=/home/wwwroot/mstplatform
RELEASE_PACKAGE_DIR=/data/release_package_ios
SCRIPT=`basename $0`
DATE=`date +%Y%m%d%H%M%S`
MYSQL_BIN_DIR=/usr/local/mysql/bin

# .erlang_cookie
# .mysql_history
# .mysql_mst_ios_s1
# .mysql_root
# .server_key
# COOKIE=`date +%s | sha256sum | base64 | head -c 32 ; echo`
COOKIE=`cat ~/.erlang_cookie_ios`

if [ ! -f ~/.erlang_cookie_ios ]
then
    echo $ERROR_RREFIX"~/.erlang_cookie non-existence: "
    exit 0
fi

if [ ! -d $RELEASE_PACKAGE_DIR ]
then
    echo $ERROR_RREFIX"RELEASE_PACKAGE_DIR non-existence: "$RELEASE_PACKAGE_DIR
    exit 0
fi

PUBLIC_IP=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"|grep -v "^10\.*"`
# LOCAL_IP=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"|grep "^10\.*"`
LOCAL_IP=`ifconfig eth0 | grep "inet addr" | cut -d ":" -f 2 | cut -d " " -f 1 | cut -d "." -f 1-4`
# echo $LOCAL_IP

################## import server ##################

cd $RELEASE_PACKAGE_DIR

for i in $( seq 1 6 )
do
    SCREEN_NAME=mstios0${i}
    SERVER_DIR=/data/myserver${i}

    DATABASE_NAME=mst_ios_s${i}
    DATABASE_USER=mst_ios_s${i}
    DATABASE_PASSWD=`cat ~/.mysql_mst_ios_s${i}`

    ERL_NODE_NAME=mst_ios_s${i}
    TCP_PORT=8300+${i}
    SERVER_ID=${i}
    PLATFORM=ios

    if [ ! -d $SERVER_DIR ]
    then
        mkdir $SERVER_DIR
        echo "mkdir "$SERVER_DIR
    fi

    if [ ! -f ~/.mysql_mst_ios_s${i} ]
    then
        echo $ERROR_RREFIX"~/.mysql_mst_ios_s${i} non-existence: "
        exit 0
    fi

    if [ -d $RELEASE_PACKAGE_DIR/myserver${i} ]
    then
        rm -rf $RELEASE_PACKAGE_DIR/myserver${i}
    fi

    if [ -f $RELEASE_PACKAGE_DIR/myserver.tar.gz ]
    then
        tar zxf $RELEASE_PACKAGE_DIR/myserver.tar.gz
        wait
        mv $RELEASE_PACKAGE_DIR/myserver $RELEASE_PACKAGE_DIR/myserver${i}
        wait
    else
	echo $ERROR_RREFIX"myserver.tar.gz not found!"
	exit 0
    fi

    if [ -d $RELEASE_PACKAGE_DIR/myserver${i} ]
    then
        cd $RELEASE_PACKAGE_DIR
        sed -i "s/server_id.*[[:digit:]]/server_id, $SERVER_ID/g" ./myserver${i}/rel/files/sys.config
        sed -i "s/tcp_port.*[[:digit:]]/tcp_port, $TCP_PORT/g" ./myserver${i}/rel/files/sys.config
	sed -i "s/platform,\(\s*\)\([a-zA-Z0-9]+\)/platform, $PLATFORM/g" ./myserver/rel/files/sys.config
        sed -i "s/db_host,\(\s*\)\"\([a-zA-Z0-9]\+\)\"/db_host, \"localhost\"/g" ./myserver${i}/rel/files/sys.config
        sed -i "s/db_user,\(\s*\)\"\([a-zA-Z0-9]\+\)\"/db_user, \"$DATABASE_USER\"/g"      ./myserver${i}/rel/files/sys.config
        sed -i "s/db_pass,\(\s*\)\"\([a-zA-Z0-9]\+\)\"/db_pass, \"$DATABASE_PASSWD\"/g" ./myserver${i}/rel/files/sys.config
        sed -i "s/db_name,\(\s*\)\"\([a-zA-Z0-9]\+\)\"/db_name, \"$DATABASE_NAME\"/g" ./myserver${i}/rel/files/sys.config
        # sed -i "s/server_id,\(\s*\)\"\([a-zA-Z0-9]+\)\"/server_id, $SERVER_ID/g" ./myserver${i}/rel/files/sys.config
        # sed -i "s/tcp_port,\(\s*\)\"\([a-zA-Z0-9]+\)\"/tcp_port, $TCP_PORT/g" ./myserver${i}/rel/files/sys.config
        # sed -i "s/-name\(\s\+\)\([a-zA-Z0-9]\+\)@\([a-zA-Z0-9.]\+\)/-name $ERL_NODE_NAME@$LOCAL_IP/g" ./myserver${i}/rel/files/vm.args
        sed -i "s/-name\(\s\+\)\([a-zA-Z0-9]\+\)@\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}/-name $ERL_NODE_NAME@$LOCAL_IP/g" ./myserver${i}/rel/files/vm.args
        sed -i "s/-setcookie\(\s\+\)\([a-zA-Z0-9]\+\)/-setcookie $COOKIE/g" ./myserver${i}/rel/files/vm.args
        sed -i "s/SCREEN_NAME=\([a-zA-Z0-9]\+\)/SCREEN_NAME=$SCREEN_NAME/g" ./myserver${i}/start_screen.sh
        chmod +x ./myserver${i}/start.sh
        chmod +x ./myserver${i}/start_screen.sh
        chmod +x ./myserver${i}/rebar
        echo "set myserver${i} ok!"
    else
        echo $ERROR_RREFIX"dir non-existence: "$RELEASE_PACKAGE_DIR/myserver${i}
        exit 0
    fi

    wait
    cp -rf ./myserver${i}/* $SERVER_DIR
    wait
    echo $SERVER_DIR" DONE"

done

if [ -f $RELEASE_PACKAGE_DIR/myserver.tar.gz ]
then
    mv $RELEASE_PACKAGE_DIR/myserver.tar.gz $RELEASE_PACKAGE_DIR/${DATE}_myserver.tar.gz
    echo "mv "myserver.tar.gz ${DATE}_myserver.tar.gz
else
    echo $ERROR_RREFIX"myserver.tar.gz not found!"
    exit 0
fi

################## export web admin ##################

# cd $RELEASE_PACKAGE_DIR
#
# if [ -d $RELEASE_PACKAGE_DIR/admin ]
# then
#     rm -rf $RELEASE_PACKAGE_DIR/admin
# fi
#
# if [ -f $RELEASE_PACKAGE_DIR/admin.tar.gz ]
# then
#     tar zxf $RELEASE_PACKAGE_DIR/admin.tar.gz
#     mv $RELEASE_PACKAGE_DIR/admin.tar.gz $RELEASE_PACKAGE_DIR/${DATE}_admin.tar.gz
#     echo "mv "admin.tar.gz ${DATE}_admin.tar.gz
# else
#     echo $ERROR_RREFIX"admin.tar.gz not found!"
#     exit 0
# fi

# if [ -d $RELEASE_PACKAGE_DIR/admin ]
# then
#     cd $RELEASE_PACKAGE_DIR
#     sed -i "s/'node'\(\s*\)=>\(\s*\)'\([^\']*\)'/'node' => '$ERL_NODE_NAME@$LOCAL_IP'/g" ./admin/app/default.cfg.php
#     sed -i "s/'cookie'\(\s*\)=>\(\s*\)'\([^\']*\)'/'cookie' => '$COOKIE'/g"              ./admin/app/default.cfg.php
#     sed -i "s/'host'\(\s*\)=>\(\s*\)'\([a-zA-Z0-9]*\)'/'host' => 'localhost'/g"          ./admin/app/default.cfg.php
#     sed -i "s/'user'\(\s*\)=>\(\s*\)'\([a-zA-Z0-9]*\)'/'user' => '$DATABASE_USER'/g"     ./admin/app/default.cfg.php
#     sed -i "s/'pass'\(\s*\)=>\(\s*\)'\([a-zA-Z0-9]*\)'/'pass' => '$DATABASE_PASSWD'/g"   ./admin/app/default.cfg.php
#     sed -i "s/'dbname'\(\s*\)=>\(\s*\)'\([a-zA-Z0-9]*\)'/'dbname' => '$DATABASE_NAME'/g" ./admin/app/default.cfg.php
#     echo "set admin ok!"
# else
#     echo $ERROR_RREFIX"dir non-existence: "$RELEASE_PACKAGE_DIR/admin
#     exit 0
# fi

# cd $RELEASE_PACKAGE_DIR
# cp -rf ./admin/* $ADMIN_DIR

wait
echo "-------------------------------------------"
echo " $SCRIPT ok!"
echo "-------------------------------------------"

# ex: ts=4 sw=4 et
# vim: set foldmethod=marker foldmarker=##',##.:
