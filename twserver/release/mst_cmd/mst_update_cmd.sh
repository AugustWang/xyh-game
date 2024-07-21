#!/bin/bash 

DATA_ROOT=`/bin/cat ~/.data_root`
PATH=$DATA_ROOT/mst_cmd
URL=svn://192.168.0.246/release/mst_cmd

SVN_USER=release
SVN_PASS=mst_at_2funfun

if [ ! -d $PATH ]
then
	echo "Error Params: " $PATH
	exit 0
fi

/usr/bin/svn export ${URL} ${PATH} --username ${SVN_USER} --password ${SVN_PASS} --no-auth-cache --force
