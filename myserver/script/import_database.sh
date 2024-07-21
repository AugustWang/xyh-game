#!/bin/bash
###############################################
# 将单表sql及数据txt导入数据库
# import_database.sh 数据库名
# 为了安全，脚本不会向已存在的数据库中导入
# 程序自己会创建数据
###############################################

MYSQL_BIN_DIR=/usr/local/mysql/bin

if [ "${1}" = "" ]; then
	echo "请输入取数据库名" 
	exit 1
fi

pass=`cat /root/.mysqlroot |grep "mysqlroot_passwd"|cut -f 2 -d "="`
db=`mysql -uroot -p"${pass}" -e"show databases"|grep ^${1}$`
if [ "${db}" != "" ]; then
	echo "数据库已经存在了。" 
	exit 1
fi

mysql -uroot -p"${pass}" -e"create database ${1}"

tb=`ls *.sql|sed 's/[\n\r\t\v]//g'`
for table in ${tb}
do
	$MYSQL_BIN_DIR/mysql -uroot -p"${pass}" ${1}<${table}
	$MYSQL_BIN_DIR/mysqlimport --local -uroot -p"${pass}" ${1} ${table/.sql/.txt}
done

echo "导入完毕"
