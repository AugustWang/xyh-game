#!/bin/bash 

if [[ ! -n $3 ]] || [[ ! -n $2 ]] || [[ ! -n $1 ]]
then
    echo "[Usage]"
    echo "mst_update.sh platform server version"
    exit 0;
fi

DATA_ROOT=`/bin/cat ~/.data_root`

EBIN_PATH=${DATA_ROOT}/mst_server/${1}_${2}/ebin
EBIN_URL=svn://192.168.0.246/release/server/${3}/ebin

SVN_USER=release
SVN_PASS=mst_at_2funfun

if [ ! -d $EBIN_PATH ]
then
	echo "Error Params: " $EBIN_PATH
	exit 0
fi

svn export ${EBIN_URL} ${EBIN_PATH} --username ${SVN_USER} --password ${SVN_PASS} --no-auth-cache --force
