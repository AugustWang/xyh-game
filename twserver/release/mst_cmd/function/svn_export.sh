svn_export(){

    URL=$1
    PATH=$2

    SVN_USER=$3
    SVN_PASS=$4

    # if [ ! -d $PATH ]
    # then
    #     echo "Error Params: " $PATH
    #     exit 0
    # fi

    /usr/bin/svn export ${URL} ${PATH} --username ${SVN_USER} --password ${SVN_PASS} --no-auth-cache --force
}
