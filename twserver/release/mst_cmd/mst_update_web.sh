#!/bin/bash 

SVN_USER=release
SVN_PASS=mst_at_2funfun

DATA_ROOT=`/bin/cat ~/.data_root`
URL_ROOT=svn://192.168.0.246/release

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

load_functions svn_export

WWW_URL_ROOT=$URL_ROOT/mst_wwwroot
WWW_DST_ROOT=$DATA_ROOT/mst_wwwroot

if [ ! -d $WWW_DST_ROOT ]
then
	echo "Error Params: " $EBIN_PATH
	exit 0
fi

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
