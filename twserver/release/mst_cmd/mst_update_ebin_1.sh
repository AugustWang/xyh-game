#!/bin/bash 

SCRIPT=`basename $0`

if [[ ! -n $4 ]] || [[ ! -n $3 ]] || [[ ! -n $2 ]] || [[ ! -n $1 ]]
then
    echo "[Usage]"
    echo $SCRIPT "platform server version mod_name"
    exit 0;
fi

DATA_ROOT=`/bin/cat ~/.data_root`

EBIN_PATH=${DATA_ROOT}/mst_server/${1}_${2}/ebin/${4}.beam
EBIN_URL=svn://192.168.0.246/release/mst_server/${3}/ebin/${4}.beam

SVN_USER=release
SVN_PASS=mst_at_2funfun

svn export ${EBIN_URL} ${EBIN_PATH} --username ${SVN_USER} --password ${SVN_PASS} --no-auth-cache --force
