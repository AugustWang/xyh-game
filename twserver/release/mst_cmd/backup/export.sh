#!/bin/sh
# @author Rolong<rolong@vip.qq.com>

SERVER_SVN_DIR=/data/myserver
ADMIN_SVN_DIR=/home/default
RELEASE_TOOLS_DIR=/data/release_tools

SCRIPT=`basename $0`
ERROR_RREFIX="[ERROR] "
DATE=`date +%Y%m%d%H%M%S`

MYSQL_BIN_DIR=/usr/local/mysql/bin
DATABASE_NAME=myserver
DATABASE_USER=dolotech
DATABASE_PASSWD=dolotech

ERL_NODE_NAME=mengshoutang01
COOKIE=`date +%s | sha256sum | base64 | head -c 32 ; echo`
TCP_PORT=8100

PUBLIC_IP=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"|grep -v "^10\.*"`
LOCAL_IP=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"|grep "^10\.*"`

if [ ! -d $RELEASE_TOOLS_DIR ]
then
	echo $ERROR_RREFIX"RELEASE_TOOLS_DIR non-existence: "$RELEASE_TOOLS_DIR
	exit 0
fi

################## export server ##################

if [ ! -d $SERVER_SVN_DIR ]
then
	echo $ERROR_RREFIX"SERVER_SVN_DIR non-existence: "$SERVER_SVN_DIR
	exit 0
fi

if [ -d $RELEASE_TOOLS_DIR/myserver ]
then
	rm -rf $RELEASE_TOOLS_DIR/myserver
	echo "rm -rf"$RELEASE_TOOLS_DIR/myserver
fi

if [ -f $RELEASE_TOOLS_DIR/myserver.tar.gz ]
then
	mv $RELEASE_TOOLS_DIR/myserver.tar.gz $RELEASE_TOOLS_DIR/${DATE}_myserver.tar.gz
	echo "mv "myserver.tar.gz ${DATE}_myserver.tar.gz
fi

if [ ! -d $RELEASE_TOOLS_DIR/myserver ]
then
	svn export --no-auth-cache $SERVER_SVN_DIR $RELEASE_TOOLS_DIR/myserver
	cd $RELEASE_TOOLS_DIR
	sed -i "s/db_host,\(\s*\)\"\([a-zA-Z0-9]\+\)\"/db_host, \"localhost\"/g" ./myserver/rel/files/sys.config
        sed -i "s/db_user,\(\s*\)\"\([a-zA-Z0-9]\+\)\"/db_user, \"$DATABASE_USER\"/g"      ./myserver/rel/files/sys.config
        sed -i "s/db_pass,\(\s*\)\"\([a-zA-Z0-9]\+\)\"/db_pass, \"$DATABASE_PASSWD\"/g" ./myserver/rel/files/sys.config
        sed -i "s/tcp_port,\(\s*\)\"\([a-zA-Z0-9]+\)\"/tcp_port, $TCP_PORT/g" ./myserver/rel/files/sys.config
        sed -i "s/-name\(\s\+\)\([a-zA-Z0-9]\+\)@\([a-zA-Z0-9.]\+\)/-name $ERL_NODE_NAME@$LOCAL_IP/g" ./myserver/rel/files/vm.args
        sed -i "s/-setcookie\(\s\+\)\([a-zA-Z0-9]\+\)/-setcookie $COOKIE/g" ./myserver/rel/files/vm.args
	tar zcf myserver.tar.gz ./myserver
	echo "Created: myserver.tar.gz"
else
	echo $ERROR_RREFIX"dir existence: "$RELEASE_TOOLS_DIR/myserver
	exit 0
fi

################## export web admin ##################

if [ ! -d $ADMIN_SVN_DIR ]
then
	echo $ERROR_RREFIX"ADMIN_SVN_DIR non-existence: "$ADMIN_SVN_DIR
	exit 0
fi

if [ -d $RELEASE_TOOLS_DIR/admin ]
then
	rm -rf $RELEASE_TOOLS_DIR/admin
	echo "rm -rf"$RELEASE_TOOLS_DIR/admin
fi

mkdir $RELEASE_TOOLS_DIR/admin
mkdir $RELEASE_TOOLS_DIR/admin/web

if [ -f $RELEASE_TOOLS_DIR/admin.tar.gz ]
then
	mv $RELEASE_TOOLS_DIR/admin.tar.gz $RELEASE_TOOLS_DIR/${DATE}_admin.tar.gz
	echo "mv "admin.tar.gz ${DATE}_admin.tar.gz
fi

if [ -d $RELEASE_TOOLS_DIR/admin ]
then
	svn export --no-auth-cache $ADMIN_SVN_DIR/sys admin/sys
	svn export --no-auth-cache $ADMIN_SVN_DIR/app admin/app
	svn export --no-auth-cache $ADMIN_SVN_DIR/web/admin admin/web/admin
	cd $RELEASE_TOOLS_DIR
	sed -i "s/'node'\(\s*\)=>\(\s*\)'\([^\']*\)'/'node' => '$ERL_NODE_NAME@$LOCAL_IP'/g" ./admin/app/default.cfg.php
	sed -i "s/'cookie'\(\s*\)=>\(\s*\)'\([^\']*\)'/'cookie' => '$COOKIE'/g"              ./admin/app/default.cfg.php
	sed -i "s/'host'\(\s*\)=>\(\s*\)'\([a-zA-Z0-9]*\)'/'host' => 'localhost'/g"          ./admin/app/default.cfg.php
	sed -i "s/'user'\(\s*\)=>\(\s*\)'\([a-zA-Z0-9]*\)'/'user' => '$DATABASE_USER'/g"     ./admin/app/default.cfg.php
	sed -i "s/'pass'\(\s*\)=>\(\s*\)'\([a-zA-Z0-9]*\)'/'pass' => '$DATABASE_PASSWD'/g"   ./admin/app/default.cfg.php
	sed -i "s/'dbname'\(\s*\)=>\(\s*\)'\([a-zA-Z0-9]*\)'/'dbname' => '$DATABASE_NAME'/g" ./admin/app/default.cfg.php
	tar zcf admin.tar.gz ./admin
	echo "Created: admin.tar.gz"
else
	echo $ERROR_RREFIX"dir existence: "$RELEASE_TOOLS_DIR/admin
	exit 0
fi

if [ -f $RELEASE_TOOLS_DIR/$DATABASE_NAME.sql ]
then
	mv $RELEASE_TOOLS_DIR/$DATABASE_NAME.sql $RELEASE_TOOLS_DIR/${DATE}_$DATABASE_NAME.sql
	echo "mv" $DATABASE_NAME.tar.gz ${DATE}_$DATABASE_NAME.tar.gz
fi

################## export database ##################

$MYSQL_BIN_DIR/mysqldump -u$DATABASE_USER -p$DATABASE_PASSWD --opt -d $DATABASE_NAME > $RELEASE_TOOLS_DIR/$DATABASE_NAME.sql
echo "Created: "$DATABASE_NAME".sql"

wait
echo "-------------------------------------------"
echo " $SCRIPT ok!"
echo "-------------------------------------------"

# ex: ts=4 sw=4 et
# vim: set foldmethod=marker foldmarker=##',##.:
