#!/bin/sh
# @author Rolong<rolong@vip.qq.com>

ERROR_RREFIX="[ERROR] "
SCREEN_NAME=mst01

if [ ! -f ~/.erlang_cookie ]
then
	echo $ERROR_RREFIX"~/.erlang_cookie non-existence: "
	exit 0
fi

if [ ! -f ~/.mysql_mengshoutang01 ]
then
	echo $ERROR_RREFIX"~/.mysql_mengshoutang01 non-existence: "
	exit 0
fi

SERVER_DIR=/gamedata1/myserver
ADMIN_DIR=/usr/local/nginx/wwwroot
RELEASE_PACKAGE_DIR=/gamedata1/release_package

SCRIPT=`basename $0`
DATE=`date +%Y%m%d%H%M%S`

MYSQL_BIN_DIR=/usr/local/mysql/bin
DATABASE_NAME=mengshoutang01
DATABASE_USER=mengshoutang01
DATABASE_PASSWD=`cat ~/.mysql_mengshoutang01`

# .erlang_cookie
# .mysql_history
# .mysql_mengshoutang01
# .mysql_root
# .server_key

ERL_NODE_NAME=mengshoutang01
# COOKIE=`date +%s | sha256sum | base64 | head -c 32 ; echo`
COOKIE=`cat ~/.erlang_cookie`
TCP_PORT=8100

PUBLIC_IP=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"|grep -v "^10\.*"`
LOCAL_IP=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"|grep "^10\.*"`

if [ ! -d $RELEASE_PACKAGE_DIR ]
then
	echo $ERROR_RREFIX"RELEASE_PACKAGE_DIR non-existence: "$RELEASE_PACKAGE_DIR
	exit 0
fi

################## import server ##################

cd $RELEASE_PACKAGE_DIR

if [ -d $RELEASE_PACKAGE_DIR/myserver ]
then
    rm -rf $RELEASE_PACKAGE_DIR/myserver
fi

if [ -f $RELEASE_PACKAGE_DIR/myserver.tar.gz ]
then
	tar zxf $RELEASE_PACKAGE_DIR/myserver.tar.gz
	wait
	mv $RELEASE_PACKAGE_DIR/myserver.tar.gz $RELEASE_PACKAGE_DIR/${DATE}_myserver.tar.gz
	echo "mv "myserver.tar.gz ${DATE}_myserver.tar.gz
else
	echo $ERROR_RREFIX"myserver.tar.gz not found!"
	exit 0
fi

if [ -d $RELEASE_PACKAGE_DIR/myserver ]
then
	cd $RELEASE_PACKAGE_DIR
    sed -i "s/db_host,\(\s*\)\"\([a-zA-Z0-9]\+\)\"/db_host, \"localhost\"/g" ./myserver/rel/files/sys.config
    sed -i "s/db_user,\(\s*\)\"\([a-zA-Z0-9]\+\)\"/db_user, \"$DATABASE_USER\"/g"      ./myserver/rel/files/sys.config
    sed -i "s/db_pass,\(\s*\)\"\([a-zA-Z0-9]\+\)\"/db_pass, \"$DATABASE_PASSWD\"/g" ./myserver/rel/files/sys.config
    sed -i "s/db_name,\(\s*\)\"\([a-zA-Z0-9]\+\)\"/db_name, \"$DATABASE_NAME\"/g" ./myserver/rel/files/sys.config
    sed -i "s/tcp_port,\(\s*\)\"\([a-zA-Z0-9]+\)\"/tcp_port, $TCP_PORT/g" ./myserver/rel/files/sys.config
    sed -i "s/-name\(\s\+\)\([a-zA-Z0-9]\+\)@\([a-zA-Z0-9.]\+\)/-name $ERL_NODE_NAME@$LOCAL_IP/g" ./myserver/rel/files/vm.args
    sed -i "s/-setcookie\(\s\+\)\([a-zA-Z0-9]\+\)/-setcookie $COOKIE/g" ./myserver/rel/files/vm.args
    sed -i "s/SCREEN_NAME=\([a-zA-Z0-9]\+\)/SCREEN_NAME=$SCREEN_NAME/g" ./myserver/start_screen.sh
    chmod +x ./myserver/start.sh
    chmod +x ./myserver/start_screen.sh
    chmod +x ./myserver/rebar
	echo "set myserver ok!"
else
	echo $ERROR_RREFIX"dir non-existence: "$RELEASE_PACKAGE_DIR/myserver
	exit 0
fi

################## export web admin ##################

cd $RELEASE_PACKAGE_DIR

if [ -d $RELEASE_PACKAGE_DIR/admin ]
then
    rm -rf $RELEASE_PACKAGE_DIR/admin
fi

if [ -f $RELEASE_PACKAGE_DIR/admin.tar.gz ]
then
    tar zxf $RELEASE_PACKAGE_DIR/admin.tar.gz
	mv $RELEASE_PACKAGE_DIR/admin.tar.gz $RELEASE_PACKAGE_DIR/${DATE}_admin.tar.gz
	echo "mv "admin.tar.gz ${DATE}_admin.tar.gz
else
	echo $ERROR_RREFIX"admin.tar.gz not found!"
	exit 0
fi

if [ -d $RELEASE_PACKAGE_DIR/admin ]
then
	cd $RELEASE_PACKAGE_DIR
	sed -i "s/'node'\(\s*\)=>\(\s*\)'\([^\']*\)'/'node' => '$ERL_NODE_NAME@$LOCAL_IP'/g" ./admin/app/default.cfg.php
	sed -i "s/'cookie'\(\s*\)=>\(\s*\)'\([^\']*\)'/'cookie' => '$COOKIE'/g"              ./admin/app/default.cfg.php
	sed -i "s/'host'\(\s*\)=>\(\s*\)'\([a-zA-Z0-9]*\)'/'host' => 'localhost'/g"          ./admin/app/default.cfg.php
	sed -i "s/'user'\(\s*\)=>\(\s*\)'\([a-zA-Z0-9]*\)'/'user' => '$DATABASE_USER'/g"     ./admin/app/default.cfg.php
	sed -i "s/'pass'\(\s*\)=>\(\s*\)'\([a-zA-Z0-9]*\)'/'pass' => '$DATABASE_PASSWD'/g"   ./admin/app/default.cfg.php
	sed -i "s/'dbname'\(\s*\)=>\(\s*\)'\([a-zA-Z0-9]*\)'/'dbname' => '$DATABASE_NAME'/g" ./admin/app/default.cfg.php
	echo "set admin ok!"
else
	echo $ERROR_RREFIX"dir non-existence: "$RELEASE_PACKAGE_DIR/admin
	exit 0
fi

cd $RELEASE_PACKAGE_DIR
cp -rf ./myserver/* $SERVER_DIR
cp -rf ./admin/* $ADMIN_DIR

wait
echo "-------------------------------------------"
echo " $SCRIPT ok!"
echo "-------------------------------------------"

# ex: ts=4 sw=4 et
# vim: set foldmethod=marker foldmarker=##',##.:
