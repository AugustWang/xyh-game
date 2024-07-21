#!/bin/bash

##################
# example:./create_db_ios.sh .mysql_mst_ios_s7 25 mst_ios_s7
# .mysql_mst_ios_s7 为密码文件名
# 25 为密码长度
# mst_ios_s7 为数据库用户和数据库名
# TODO: 7 为服务器ID,前面名字不变,方便备份维护
###################

# create password
# example:.mysql_mst_ios_s7
cd ~
if [ "${1}" = "" ]; then
    echo "请输入密码文件名"
    exit 1
fi

if [ -e "${1}" ]; then
    echo "${1} file had exist "
    exit 1
fi

if [ "${2}" = "" ]; then
    echo "请输入密码长度"
    exit 1
fi

if [ ${2} -lt 10 ]; then
    echo "密码长度小于10"
    exit 1
fi

if [ "${3}" = "" ]; then
    echo "请输入创建的用户名"
    exit 1
fi
echo `date +%s | sha256sum | base64 | head -c ${2}` > ${1}
echo "create ${1} done"

# create db
# example:mst_ios_s7
DB_USER=${3}
DB_NAME=${3}
# ROOT_PASS=0086
ROOT_PASS=`cat ~/.mysql_root`
DB_HOST=localhost
DB_PASS=`cat ~/${1}`
DATE=`date +%Y%m%d%H%M%S`
DIR=/data/release_package_ios

db=`mysql -uroot -p${ROOT_PASS} -e"show databases"|grep ^${3}$`
if [ "${db}" != "" ]; then
    echo "${DB_NAME} IS ALREADY EXIST."
    exit 1
fi

mysql -uroot -p${ROOT_PASS} -e"CREATE USER '${DB_USER}'@'${DB_HOST}' IDENTIFIED BY '${DB_PASS}';"
mysql -uroot -p${ROOT_PASS} -e"GRANT USAGE ON * . * TO '${DB_USER}'@'${DB_HOST}' IDENTIFIED BY '${DB_PASS}' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ;"
mysql -uroot -p${ROOT_PASS} -e"CREATE DATABASE IF NOT EXISTS ${DB_NAME} ;"
mysql -uroot -p${ROOT_PASS} -e"GRANT ALL PRIVILEGES ON ${DB_NAME} . * TO '${DB_USER}'@'${DB_HOST}';"
mysql -uroot -p${ROOT_PASS} -e"GRANT FILE ON * . * TO '${DB_USER}'@'${DB_HOST}';"

if [ -f $DIR/myserver.sql ]; then
    cd $DIR
    # tb=`myserver.sql|sed 's/[\n\r\t\v]//g'`
    mysql -u${DB_USER} -p${DB_PASS} ${DB_NAME}<myserver.sql
    wait
else
    echo $DIR" myserver.sql not found."
fi

echo "create db user ${3} done"
