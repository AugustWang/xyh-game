#!/bin/sh
# @author Rolong<rolong@vip.qq.com>

CUR_DIR=`pwd`
ADMIN_SVN_DIR=/home/default

MYSQL_BIN_DIR=/usr/local/mysql/bin
MYSQLROOT_PASSWD=dolotech
DATABASE_NAME=myserver



# REL_DIR=$CUR_DIR/cc_release
# IP=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"|grep -v 10.*`
# #TAG_IP=127.0.0.1
# UPGRADE_DIR=$CUR_DIR/cc_upgrade
# SCRIPT=`basename $0`
# CC_REL_FILE_NAME=cc.tar.gz
# CC_CODE_DIR=/data/cc_code
# 
# # export env
# TAG_IP=216.12.208.210
# SVN_DIR=/home/dev/
# 
# # import env
# SERVER_ID=1
# COOKIE=`date +%s | sha256sum | base64 | head -c 32 ; echo`
# ERL_NODE_NAME=cc
# TCP_PORT=8000
# HOST_DIR=/home/server$SERVER_ID
# 
# ##' generate upgrade package
# generate_upgrade (){
#     gen_dir=$SVN_DIR/cc/rel
#     cur_vsn=`cat $gen_dir/reltool.config |grep '{rel, "cc", "\([0-9]\+\)"'|awk -F '"' '{print$4}'`
#     new_vsn=$(( $cur_vsn + 1 ))
#     mv $gen_dir/cc $gen_dir/cc_$cur_vsn
#     sed -i "s/{rel, \"cc\", \"\([0-9]\+\)\"/{rel, \"cc\", \"$new_vsn\"/g" $gen_dir/reltool.config
#     sed -i "s/{vsn, \"\([0-9]\+\)\"}/{vsn, \"$new_vsn\"}/g" $SVN_DIR/cc/src/cc.app.src
#     cd $SVN_DIR/cc/
#     ./rebar compile
#     ./rebar generate
#     ./rebar generate-appups previous_release=cc_$cur_vsn
#     ./rebar generate-upgrade previous_release=cc_$cur_vsn
#     if [ ! -d $UPGRADE_DIR ]
#     then
#         mkdir $UPGRADE_DIR
#     fi
#     mv ./rel/cc_$new_vsn.tar.gz $UPGRADE_DIR
#     echo "Create cc_$new_vsn.tar.gz OK!"
# }
# ##.
# 
# ##' set version number
# set_vsn (){
#     if [ -z "$1" ]
#     then
#         echo "Please input version number!"
#         exit 0
#     else
#         gen_dir=$SVN_DIR/cc/rel
#         new_vsn=$1
#         sed -i "s/{rel, \"cc\", \"\([0-9]\+\)\"/{rel, \"cc\", \"$new_vsn\"/g" $gen_dir/reltool.config
#         sed -i "s/{vsn, \"\([0-9]\+\)\"}/{vsn, \"$new_vsn\"}/g" $SVN_DIR/cc/src/cc.app.src
#     fi
# }
# ##.
# 
# ##' send file
# send (){
#     case "$1" in
#         main)
#             scp $SVN_DIR/web/game/Main.swf root@$TAG_IP:$HOST_DIR/web/game/
#             scp $SVN_DIR/web/game/MainLoading.swf root@$TAG_IP:$HOST_DIR/web/game/
#             ;;
#         upgrade)
#             scp $UPGRADE_DIR/*\.tar\.gz root@$TAG_IP:/$HOST_DIR/cc/update/
#             if [ ! -d $UPGRADE_DIR/backup ]
#             then
#                 mkdir $UPGRADE_DIR/backup
#             fi
#             mv $UPGRADE_DIR/*\.tar\.gz $UPGRADE_DIR/backup/
#             ;;
#         beam)
#             if [ -z "$2" ]
#             then
#                 echo "Please input erlang module name!"
#                 exit 0
#             else
#                 scp $SVN_DIR/cc/ebin/$2.beam root@$TAG_IP:$HOST_DIR/cc/update/
#             fi
#             ;;
#         release)
#             scp ./cc_release.tar.gz root@$TAG_IP:/root/myserver
#             ;;
#         *)
#             exit 0
#             ;;
#     esac
# }
# ##.

##' Export server
export_server (){
    # cd $CUR_DIR
    # rm -rf ./rel/myserver
    # # ./rebar clean
    # ./rebar compile
    # ./rebar generate
    # cd ./rel
    # tar zcf mengshoutang.tar.gz myserver
    # mv mengshoutang.tar.gz ../
    # echo "Created: mengshoutang.tar.gz"
	cd $CUR_DIR
	if [ ! -d ../mengshoutang ]
	then
        cd ../
        svn export --no-auth-cache ./myserver ./mengshoutang
        tar zcf mengshoutang.tar.gz ./mengshoutang
        mv mengshoutang.tar.gz ./myserver/
        echo "Created: mengshoutang.tar.gz"
    else
        echo "Todo: rm ../mengshoutang"
	fi
}
##.

##' Export server
export_sql (){
    cd $CUR_DIR
    $MYSQL_BIN_DIR/mysqldump -udolotech -pdolotech --opt -d myserver > $CUR_DIR/myserver.sql
    echo "Created: myserver.sql"
}
##.

##' Export admin
export_admin (){
	cd $CUR_DIR/rel
	if [ ! -d ./admin/web ]
	then
		mkdir -p ./admin/web
	fi
	svn export --no-auth-cache $ADMIN_SVN_DIR/sys admin/sys
	svn export --no-auth-cache $ADMIN_SVN_DIR/app admin/app
	svn export --no-auth-cache $ADMIN_SVN_DIR/web/admin admin/web/admin
    tar zcf admin.tar.gz admin
    mv admin.tar.gz ../
	echo "Created: admin.tar.gz"
}
##.

##' Export ropeb
export_ropeb (){
	cd $CUR_DIR/rel
	if [ ! -d ./admin/web ]
	then
		mkdir -p ./admin/web
	fi
	svn export --no-auth-cache $ADMIN_SVN_DIR/sys admin/sys
	svn export --no-auth-cache $ADMIN_SVN_DIR/app admin/app
	svn export --no-auth-cache $ADMIN_SVN_DIR/web/admin admin/web/admin
    tar zcf admin.tar.gz admin
    mv admin.tar.gz ../
	echo "Created: admin.tar.gz"
}
##.

##' export src
export_code (){
    rm -rf $CC_CODE_DIR
    svn export --username rolong --password erlang --no-auth-cache $SVN_DIR $CC_CODE_DIR/
    rm -rf $CC_CODE_DIR/web/res/data/*
    rm -rf $CC_CODE_DIR/doc
    rm -rf $CC_CODE_DIR/web/db
    rm -rf $CC_CODE_DIR/web/res/server
    rm -rf $CC_CODE_DIR/release
    cp $SVN_DIR/cc/rebar                 $CC_CODE_DIR/cc/
    cp $SVN_DIR/cc/src/data/*            $CC_CODE_DIR/cc/src/data/
    cp $SVN_DIR/web/res/data/*           $CC_CODE_DIR/web/res/data/
    cp $SVN_DIR/web/game/Main.swf        $CC_CODE_DIR/web/game/Main.swf
    cp $SVN_DIR/web/game/MainLoading.swf $CC_CODE_DIR/web/game/MainLoading.swf
    find $CC_CODE_DIR/web -name *\.txt -type f -exec rm -f {} \; 
    find $CC_CODE_DIR/web -name *\.fla -type f -exec rm -f {} \; 
    find $CC_CODE_DIR/web -name \.svn -type f -exec rm -f {} \; 
}
##.

##' sync_code
sync_code (){
    rsync -avzP dolotech@58.61.153.166::cc_code /home/dev
}
##.

##' Import release
import_release (){
    rm -rf ./cc_release
    tar zxf cc_release.tar.gz
    cd cc_release
    mv ./release/$CC_REL_FILE_NAME ./
    tar zxf $CC_REL_FILE_NAME
    cd ..
    if [ -n "$1" -a -d ./cc_release/cc/releases/$1 ]
    then
        sed -i "s/'host'\(\s*\)=>\(\s*\)'\([a-zA-Z0-9]*\)'/'host' => '127.0.0.1'/g" ./cc_release/app/default.cfg.php
        sed -i "s/'user'\(\s*\)=>\(\s*\)'\([a-zA-Z0-9]*\)'/'user' => 'root'/g" ./cc_release/app/default.cfg.php
        sed -i "s/'pass'\(\s*\)=>\(\s*\)'\([a-zA-Z0-9]*\)'/'pass' => '$MYSQLROOT_PASSWD'/g" ./cc_release/app/default.cfg.php
        sed -i "s/<ip>\([0-9.]*\)<\/ip>/<ip>$TAG_IP<\/ip>/g" ./cc_release/web/res/config.xml
        sed -i "s/db_host,\(\s*\)\"\([a-zA-Z0-9]\+\)\"/db_host, \"127.0.0.1\"/g" ./cc_release/cc/releases/$1/sys.config
        sed -i "s/db_user,\(\s*\)\"\([a-zA-Z0-9]\+\)\"/db_user, \"root\"/g" ./cc_release/cc/releases/$1/sys.config
        sed -i "s/db_pass,\(\s*\)\"\([a-zA-Z0-9]\+\)\"/db_pass, \"$MYSQLROOT_PASSWD\"/g" ./cc_release/cc/releases/$1/sys.config
        sed -i "s/tcp_port,\(\s*\)\"\([a-zA-Z0-9]+\)\"/tcp_port, $TCP_PORT/g" ./cc_release/cc/releases/$1/sys.config
        sed -i "s/-name\(\s\+\)\([a-zA-Z0-9]\+\)@\([a-zA-Z0-9.]\+\)/-name $ERL_NODE_NAME@$TAG_IP/g" ./cc_release/cc/releases/$1/vm.args
        sed -i "s/-setcookie\(\s\+\)\([a-zA-Z0-9]\+\)/-setcookie $COOKIE/g" ./cc_release/cc/releases/$1/vm.args
        # mysql -uroot -p$MYSQLROOT_PASSWD $DATABASE_NAME < ./cc_release/$DATABASE_NAME.sql
        rm -rf ./cc_release/$CC_REL_FILE_NAME
        rm -rf ./cc_release/release
        cp -rf ./cc_release/* $HOST_DIR/
        echo "import version: ${1}"
    else
        if [ -z "$1" ]
        then
            echo "Please input version number!"
        else
            echo "incorrect version: ${1}"
        fi
        exit 0
    fi
}
##.

##' Set env
set_env (){
    ldd $(which /home/default/release/cc/lib/crypto-2.1/priv/lib/crypto.so)
    ln /usr/lib64/libssh2.so.1 /usr/lib64/libssl.so.6
    ln /usr/lib64/libcrypto.so.1.0.0 /usr/lib64/libcrypto.so.6
    # yum provides */libncurses.so.5
}
##.

case "$1" in
    export_server) export_server ;;
    export_admin) export_admin ;;
    export_sql) export_sql ;;
#     export) export_server ;;
#     set_vsn) set_vsn $2 ;;
#     generate_upgrade) generate_upgrade ;;
#     export_code) export_code ;;
#     sync_code) sync_code ;;
#     export_web)
#         cd $SVN_DIR/cc/
#         rm -rf ./rel/cc
#         # ./rebar compile
#         # ./rebar generate
#         # cd ./rel
#         # tar zcf cc.tar.gz cc
#         # mv cc.tar.gz ../../release/
#         cd $CUR_DIR
#         rm -rf $REL_DIR
#         svn export --username rolong --password erlang --no-auth-cache $SVN_DIR $REL_DIR
#         rm -rf $REL_DIR/web/res/data/*
#         rm -rf $REL_DIR/cc
#         rm -rf $REL_DIR/web/db
#         rm -rf $REL_DIR/web/res/server
#         cp $SVN_DIR/web/res/data/*           $REL_DIR/web/res/data/
#         cp $SVN_DIR/web/game/Main.swf        $REL_DIR/web/game/Main.swf
#         cp $SVN_DIR/web/game/MainLoading.swf $REL_DIR/web/game/MainLoading.swf
#         # cp $SVN_DIR/release/*                $REL_DIR/release/
#         find $REL_DIR/web -name *\.txt -type f -exec rm -f {} \; 
#         find $REL_DIR/web -name *\.fla -type f -exec rm -f {} \; 
#         # $MYSQL_BIN_DIR/mysqldump -uroot -p"$MYSQLROOT_PASSWD" $DATABASE_NAME > $REL_DIR/$DATABASE_NAME.sql
#         tar zcf cc_release.tar.gz cc_release
#         ;;
#     import_release) import_release $2 ;;
#     import_web)
#         rm -rf ./cc_release
#         tar zxf cc_release.tar.gz
#         cd cc_release
#         # mv ./release/$CC_REL_FILE_NAME ./
#         # tar zxf $CC_REL_FILE_NAME
#         cd ..
#         sed -i "s/'host'\(\s*\)=>\(\s*\)'\([a-zA-Z0-9]*\)'/'host' => '127.0.0.1'/g" ./cc_release/app/default.cfg.php
#         sed -i "s/'user'\(\s*\)=>\(\s*\)'\([a-zA-Z0-9]*\)'/'user' => 'root'/g" ./cc_release/app/default.cfg.php
#         sed -i "s/'pass'\(\s*\)=>\(\s*\)'\([a-zA-Z0-9]*\)'/'pass' => '$MYSQLROOT_PASSWD'/g" ./cc_release/app/default.cfg.php
#         sed -i "s/<ip>\([0-9.]*\)<\/ip>/<ip>$TAG_IP<\/ip>/g" ./cc_release/web/res/config.xml
#         # sed -i "s/db_host,\(\s*\)\"\([a-zA-Z0-9]\+\)\"/db_host, \"127.0.0.1\"/g" ./cc_release/cc/releases/$2/sys.config
#         # sed -i "s/db_user,\(\s*\)\"\([a-zA-Z0-9]\+\)\"/db_user, \"root\"/g" ./cc_release/cc/releases/$2/sys.config
#         # sed -i "s/db_pass,\(\s*\)\"\([a-zA-Z0-9]\+\)\"/db_pass, \"$MYSQLROOT_PASSWD\"/g" ./cc_release/cc/releases/$2/sys.config
#         # sed -i "s/tcp_port,\(\s*\)\"\([a-zA-Z0-9]+\)\"/tcp_port, $TCP_PORT/g" ./cc_release/cc/releases/$2/sys.config
#         # sed -i "s/-name\(\s\+\)\([a-zA-Z0-9]\+\)@\([a-zA-Z0-9.]\+\)/-name $ERL_NODE_NAME@$TAG_IP/g" ./cc_release/cc/releases/$2/vm.args
#         # sed -i "s/-setcookie\(\s\+\)\([a-zA-Z0-9]\+\)/-setcookie $COOKIE/g" ./cc_release/cc/releases/$2/vm.args
#         # mysql -uroot -p$MYSQLROOT_PASSWD $DATABASE_NAME < ./cc_release/$DATABASE_NAME.sql
#         rm -rf ./cc_release/$CC_REL_FILE_NAME
#         rm -rf ./cc_release/release
#         cp -rf ./cc_release/* $HOST_DIR/
#         ;;
#     send)
#         if [ -z "$2" ]
#         then
#             echo "Please input target file name!"
#             exit 0
#         else
#             send $2 $3
#         fi
#         ;;
#     set_env) set_env ;;
    *)
        echo "Usage: $SCRIPT {export|import|sned File|set_vsn|set_env}"
        exit 1
        ;;
esac

#exit 0
wait
echo "-------------------------------------------"
echo " ${1} ${2} ok!"
echo "-------------------------------------------"

# ex: ts=4 sw=4 et
# vim: set foldmethod=marker foldmarker=##',##.:
