#!/bin/sh
# @doc export server code
# @author rolong@vip.qq.com

SCRIPT=`basename $0`

CODE_SVN_DIR=/home/dev
CC_CODE_DIR=/data/cc_code

PLATFORM_SVN_DIR=/home/hammer01.com
PLATFORM_CODE_DIR=/data/platform_code

export_code(){
    rm -rf $CC_CODE_DIR
    svn export --no-auth-cache $CODE_SVN_DIR $CC_CODE_DIR/
    rm -rf $CC_CODE_DIR/web/res/data/*
    rm -rf $CC_CODE_DIR/web/d_a_t_a/*
    rm -rf $CC_CODE_DIR/doc
    rm -rf $CC_CODE_DIR/web/db
    rm -rf $CC_CODE_DIR/web/res/server
    rm -rf $CC_CODE_DIR/release/*
    cp $CODE_SVN_DIR/cc/src/data/*            $CC_CODE_DIR/cc/src/data/
    cp $CODE_SVN_DIR/web/res/data/*           $CC_CODE_DIR/web/res/data/
    cp $CODE_SVN_DIR/web/game/Main.swf        $CC_CODE_DIR/web/game/Main.swf
    cp $CODE_SVN_DIR/web/game/MainLoading.swf $CC_CODE_DIR/web/game/MainLoading.swf
    cd $CC_CODE_DIR
    find $CC_CODE_DIR/web -name *\.txt -type f -exec rm -f {} \; 
    find $CC_CODE_DIR/web -name *\.fla -type f -exec rm -f {} \; 
    find $CC_CODE_DIR/web -name \.svn -type f -exec rm -f {} \; 
    find $CC_CODE_DIR -name *\.cmd -type f -exec rm -f {} \; 
    find $CC_CODE_DIR -name *\.bat -type f -exec rm -f {} \; 
    find $CC_CODE_DIR -name *\.beam -type f -exec rm -f {} \; 
}

export_platform(){
    rm -rf $PLATFORM_CODE_DIR
    svn export --no-auth-cache $PLATFORM_SVN_DIR $PLATFORM_CODE_DIR/
}

case "$1" in
    code) 
        export_code
        ;;
    platform)
        export_platform
        ;;
    all)
        export_code
        export_platform
        ;;
    *)
        echo "Usage: $SCRIPT {code | platform | export_platform}"
        exit 1
        ;;
esac

wait
echo "-------------------------------------------"
echo " ${1} ok!"
echo "-------------------------------------------"

# ex: ts=4 sw=4 et
# vim: set foldmethod=marker foldmarker=##',##.:
