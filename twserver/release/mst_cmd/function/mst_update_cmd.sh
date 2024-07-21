mst_update_cmd(){

    PATH=$1
    URL=svn://192.168.0.246/release/cmd

    SVN_USER=release
    SVN_PASS=mst_at_2funfun

    if [ ! -d $PATH ]
    then
        echo "Error Params: " $PATH
        exit 0
    fi

    /usr/bin/svn export ${URL} ${PATH} --username ${SVN_USER} --password ${SVN_PASS} --no-auth-cache --force
}
