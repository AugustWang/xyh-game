#!/bin/bash

if [[ ! -n $3 ]] || [[ ! -n $2 ]] || [[ ! -n $1 ]]
then
    echo "[Usage]"
    echo "new_server.sh platform server version"
    exit 0;
fi

if [ ! -f ~/.data_root ]; then
    echo "No File: ~/.data_root"
    exit 0;
fi

if [ ! -f ~/.mysql_root ]; then
    echo "No File: ~/.mysql_root"
    exit 0;
fi

if [ ! -f ~/.local_ip ]; then
    echo "No File: ~/.local_ip"
    exit 0;
fi

DATA_ROOT=`/bin/cat ~/.data_root`
LOCAL_IP=`/bin/cat ~/.local_ip`

#################################################
################ EDIT CONFIG ####################

PLATFORM=$1
SERVER_NTH=$2
SERVER_ID=`expr $2 + 200`
VERSION=$3

SERVER_NAME=${PLATFORM}_${SERVER_NTH}

TCP_PORT=`expr $2 + 8000`

DB_HOST=127.0.0.1
DB_USER=mst_${SERVER_NAME}
DB_PASS_PATH=~/.mysql_${DB_USER}
DB_NAME=$DB_USER

NODE=${SERVER_NAME}@${LOCAL_IP}

URL_ROOT=svn://192.168.0.246/release

SVN_USER=release
SVN_PASS=mst_at_2funfun

#################################################
#################################################

COOKIE_PATH=~/.cookie_${SERVER_NAME}

if [ ! -f $DB_PASS_PATH ]; then
    echo `/bin/date +%s | /usr/bin/sha256sum | /usr/bin/base64 | /usr/bin/head -c 16` > $DB_PASS_PATH
    echo "create ${DB_PASS_PATH}"
fi

if [ ! -f $COOKIE_PATH ]; then
    echo `/bin/date +%s | /usr/bin/sha256sum | /usr/bin/base64 | /usr/bin/head -c 32` > $COOKIE_PATH
    echo "create ${COOKIE_PATH}"
fi

DB_PASS=`/bin/cat $DB_PASS_PATH`
COOKIE=`/bin/cat $COOKIE_PATH`


mst_mkdir(){
    if [ ! -d $1 ]
    then
        mkdir $1
        echo "mkdir" $1
    fi
}

mst_chk_file(){
    if [ ! -f $1 ]
    then
        echo "No File:" $1
        exit 0
    fi
}


#载入函数
load_functions(){
    local function=$1
    if [[ -s $DATA_ROOT/mst_cmd/function/${function}.sh ]];then
        . $DATA_ROOT/mst_cmd/function/${function}.sh
    else
        echo "$DATA_ROOT/mst_cmd/function/${function}.sh not found,shell can not be executed."
        exit 1
    fi	
}

main(){
    mst_mkdir $DATA_ROOT
    mst_mkdir $DATA_ROOT/mst_cmd
    mst_mkdir $DATA_ROOT/mst_server
    cd $DATA_ROOT

    SRV_URL_ROOT=$URL_ROOT/mst_server/$VERSION
    SRV_DST_ROOT=$DATA_ROOT/mst_server/$SERVER_NAME

    if [ -d $SRV_DST_ROOT ]
    then
        echo "Already exists:" $SRV_DST_ROOT
        exit 1
    fi

    /usr/bin/svn export ${URL_ROOT}/mst_cmd $DATA_ROOT/mst_cmd --username ${SVN_USER} --password ${SVN_PASS} --no-auth-cache --force

    load_functions svn_export
    load_functions create_db

    SRV_DST_SYS=$SRV_DST_ROOT/rel/files/sys.config
    SRV_DST_VMS=$SRV_DST_ROOT/rel/files/vm.args

    mst_mkdir $SRV_DST_ROOT
    mst_mkdir $SRV_DST_ROOT/dets
    mst_mkdir $SRV_DST_ROOT/log
    mst_mkdir $SRV_DST_ROOT/mnesia
    mst_mkdir $SRV_DST_ROOT/rel
    mst_mkdir $SRV_DST_ROOT/rel/files
    mst_mkdir $SRV_DST_ROOT/update

    svn_export $SRV_URL_ROOT/ebin $SRV_DST_ROOT/ebin $SVN_USER $SVN_PASS
    svn_export $SRV_URL_ROOT/Makefile $SRV_DST_ROOT/Makefile $SVN_USER $SVN_PASS
    svn_export $SRV_URL_ROOT/crontab.config $SRV_DST_ROOT/crontab.config $SVN_USER $SVN_PASS
    svn_export $SRV_URL_ROOT/rel/files/sys.config $SRV_DST_SYS $SVN_USER $SVN_PASS
    svn_export $SRV_URL_ROOT/rel/files/vm.args $SRV_DST_VMS $SVN_USER $SVN_PASS


    WWW_URL_ROOT=$URL_ROOT/mst_wwwroot
    WWW_DST_ROOT=$DATA_ROOT/mst_wwwroot

    svn_export $WWW_URL_ROOT $WWW_DST_ROOT $SVN_USER $SVN_PASS

    WWW_DST_CFG=$WWW_DST_ROOT/app/${SERVER_NAME}.cfg.php
    WWW_DST_IDX=$WWW_DST_ROOT/web/admin/${SERVER_NAME}.php

    /bin/cp -f $DATA_ROOT/mst_cmd/conf/admin.cfg.php $WWW_DST_CFG
    /bin/cp -f $DATA_ROOT/mst_cmd/conf/admin.index.php $WWW_DST_IDX



    /bin/sed -i "s/'server_name'\(\s*\)=>\(\s*\)'\([^\']*\)'/'server_name' => '萌獸堂 ${SERVER_NTH}區'/g" $WWW_DST_CFG
    /bin/sed -i "s/'server_id'\(\s*\)=>\(\s*\)'\([^\']*\)'/'server_id' => '$SERVER_ID'/g" $WWW_DST_CFG
    /bin/sed -i "s/'version'\(\s*\)=>\(\s*\)'\([^\']*\)'/'version' => '$VERSION'/g" $WWW_DST_CFG
    /bin/sed -i "s/'node'\(\s*\)=>\(\s*\)'\([^\']*\)'/'node' => '$NODE'/g"              $WWW_DST_CFG
    /bin/sed -i "s/'cookie'\(\s*\)=>\(\s*\)'\([^\']*\)'/'cookie' => '$COOKIE'/g"        $WWW_DST_CFG
    /bin/sed -i "s/'host'\(\s*\)=>\(\s*\)'\([^\']*\)'/'host' => 'localhost'/g"    $WWW_DST_CFG
    /bin/sed -i "s/'user'\(\s*\)=>\(\s*\)'\([^\']*\)'/'user' => '$DB_USER'/g"     $WWW_DST_CFG
    /bin/sed -i "s/'pass'\(\s*\)=>\(\s*\)'\([^\']*\)'/'pass' => '$DB_PASS'/g"     $WWW_DST_CFG
    /bin/sed -i "s/'dbname'\(\s*\)=>\(\s*\)'\([^\']*\)'/'dbname' => '$DB_NAME'/g" $WWW_DST_CFG

    /bin/sed -i "s/'APP_CFG'\(\s*\),\(\s*\)'\([^\']*\)'/'APP_CFG', '$SERVER_NAME'/g" $WWW_DST_IDX

    /bin/sed -i "s/{version\(\s*\),\(\s*\)\([^\}}]*\)}/{version, \"$VERSION\"}/g"                               $SRV_DST_SYS
    /bin/sed -i "s/{version_type\(\s*\),\(\s*\)\([^\}}]*\)}/{version_type, rel}/g"                               $SRV_DST_SYS
    /bin/sed -i "s/{server_id\(\s*\),\(\s*\)\([^\}}]*\)}/{server_id, $SERVER_ID}/g"                               $SRV_DST_SYS
    /bin/sed -i "s/{tcp_port\(\s*\),\(\s*\)\([^\}]*\)}/{tcp_port, $TCP_PORT}/g"                               $SRV_DST_SYS
    /bin/sed -i "s/{platform\(\s*\),\(\s*\)\([^\}]*\)}/{platform, $PLATFORM}/g"                               $SRV_DST_SYS
    /bin/sed -i "s/{db_host\(\s*\),\([^\}]\+\)\}/{db_host, \"localhost\"}/g"                    $SRV_DST_SYS
    /bin/sed -i "s/{db_user\(\s*\),\([^\}]\+\)\}/{db_user, \"$DB_USER\"}/g"                     $SRV_DST_SYS
    /bin/sed -i "s/{db_pass\(\s*\),\([^\}]\+\)\}/{db_pass, \"$DB_PASS\"}/g"                     $SRV_DST_SYS
    /bin/sed -i "s/{db_name\(\s*\),\([^\}]\+\)\}/{db_name, \"$DB_NAME\"}/g"                     $SRV_DST_SYS
    /bin/sed -i "s/-name \([^\ ]\+\)/-name $NODE/g" $SRV_DST_VMS
    /bin/sed -i "s/-setcookie \([^\ ]\+\)/-setcookie $COOKIE/g"                         $SRV_DST_VMS

    create_db ${DB_USER} ${DB_PASS} $DATA_ROOT/mst_cmd/sql
}

# Go ...
rm -f /root/mst.log
main 2>&1 | tee -a /root/mst.log
