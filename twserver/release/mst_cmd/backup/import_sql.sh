#!/bin/sh
# @author Rolong<rolong@vip.qq.com>

RELEASE_PACKAGE_DIR=/gamedata1/release_package

SCRIPT=`basename $0`
ERROR_RREFIX="[ERROR] "

MYSQL_BIN_DIR=/usr/local/mysql/bin
DATABASE_NAME=mengshoutang01
DATABASE_USER=mengshoutang01
DATABASE_PASSWD=`cat ~/.mysql_mengshoutang01`

# .erlang_cookie
# .mysql_history
# .mysql_mengshoutang01
# .mysql_root
# .server_key

if [ ! -f $RELEASE_PACKAGE_DIR/myserver.sql ]
then
	echo $ERROR_RREFIX"myserver.sql non-existence: "
	exit 0
fi

mysql -u$DATABASE_USER -p$DATABASE_PASSWD $DATABASE_NAME < $RELEASE_PACKAGE_DIR/myserver.sql

wait
echo "-------------------------------------------"
echo " $SCRIPT ok!"
echo "-------------------------------------------"

# ex: ts=4 sw=4 et
# vim: set foldmethod=marker foldmarker=##',##.:
