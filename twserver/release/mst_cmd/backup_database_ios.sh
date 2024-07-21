#!/bin/bash

show_help() {
    echo "Usage:"
    echo "$0"
    exit 1
}

if [ "${1}" = "" ]; then
    echo "PLEASE ENTER SERVER ID"
    exit 1
fi

db_name=mst_ios_s${1}
db_host=localhost
db_pass=`cat ~/.mysql_mst_ios_s${1}`

get_curr_time() {
    echo `date +"%Y-%m-%d %H:%M:%S"`
}

get_curr_day() {
    echo `date +"%Y-%m-%d"`
}

save_log() {
    echo "" >> ${LOGFILE}
    echo "Time: "`get_curr_time`"   $1 " >> ${LOGFILE}
}

ORIGDIR="/data/mst_backup_ios/database"
MYSQLDUMP="/usr/local/mysql/bin/mysqldump"
TAR="/bin/tar"

CURRDAY=`get_curr_day`
BACKUPPARENTDIR="${ORIGDIR}/${db_name}"
BACKUPDIR="${BACKUPPARENTDIR}/${CURRDAY}"
BACKUPFILENAME="${BACKUPPARENTDIR}/${db_name}_${CURRDAY}.tar.bz2"

mkdir -p ${BACKUPPARENTDIR}

LOGFILE="${ORIGDIR}/backup_database${1}.log"
echo "" >> ${LOGFILE}
echo "=======================================================================" >> ${LOGFILE}

# 目录或文件已经存在，则程序退出
if [ -d "${BACKUPDIR}" ]
then
    echo "${BACKUPDIR} directory had exist! "
    save_log "${BACKUPDIR} directory had exist! "
    exit 1
fi
if [ -e "${BACKUPFILENAME}" ]
then
    echo "${BACKUPFILENAME} file had exist! "
    save_log "${BACKUPFILENAME} file had exist! "
    exit 1
fi

mkdir -p ${BACKUPDIR}

# 确保目录结构与目录权限(必须mysql用户有权限读写)
chown mysql:mysql "${LOGFILE}"
chmod 770 "${LOGFILE}"
chown mysql:mysql "${BACKUPPARENTDIR}"
chmod 770 "${BACKUPPARENTDIR}"
chown mysql:mysql ${BACKUPDIR}
chmod 770 ${BACKUPDIR}

cd ${BACKUPPARENTDIR}

# 只导出整个数据库结构，不包括内容
save_log "Start dump ${db_name} structure to ${BACKUPDIR}/${db_name}_db_struc.sql"
${MYSQLDUMP} -h${db_host} -u${db_name} -p${db_pass} -d ${db_name} > "${BACKUPDIR}/${db_name}_db_struc.sql"

# 以 txt 文件的方式分表导出数据
save_log "Start dump ${db_name} all data to DIR ${BACKUPDIR}"
${MYSQLDUMP} -u${db_name} -p${db_pass} -T${BACKUPDIR}  ${db_name}

# 打包导出的数据
save_log "Start compress to ${BACKUPFILENAME}"
cd ${BACKUPPARENTDIR}
${TAR} cjvf ${BACKUPFILENAME} ${CURRDAY}

# 完成操作
save_log "BACKUP DATABASE ${db_name} SUCCEED"
