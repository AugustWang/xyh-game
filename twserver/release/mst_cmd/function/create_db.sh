create_db(){

    if [ "${1}" = "" ]; then
        echo "NO USER"
        exit 1
    fi

    if [ "${2}" = "" ]; then
        echo "NO PASS"
        exit 1
    fi

    if [ ! -d $3 ]
    then
        echo "No SQL File:" $3
        exit 0
    fi

    # create db
    # example:mst_ios_s7
    DB_USER=$1
    DB_NAME=$1
    SQL_DIR=$3
    # ROOT_PASS=0086
    ROOT_PASS=`/bin/cat ~/.mysql_root`
    DB_HOST=localhost
    DB_PASS=$2

    db=`/usr/local/mysql/bin/mysql -uroot -p${ROOT_PASS} -e"show databases"|/bin/grep ^${1}$`
    if [ "${db}" != "" ]; then
        echo "${DB_NAME} IS ALREADY EXIST."
        exit 1
    fi

    /usr/local/mysql/bin/mysql -uroot -p${ROOT_PASS} -e"CREATE USER '${DB_USER}'@'${DB_HOST}' IDENTIFIED BY '${DB_PASS}';"
    /usr/local/mysql/bin/mysql -uroot -p${ROOT_PASS} -e"GRANT USAGE ON * . * TO '${DB_USER}'@'${DB_HOST}' IDENTIFIED BY '${DB_PASS}' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ;"
    /usr/local/mysql/bin/mysql -uroot -p${ROOT_PASS} -e"CREATE DATABASE IF NOT EXISTS ${DB_NAME} ;"
    /usr/local/mysql/bin/mysql -uroot -p${ROOT_PASS} -e"GRANT ALL PRIVILEGES ON ${DB_NAME} . * TO '${DB_USER}'@'${DB_HOST}';"
    /usr/local/mysql/bin/mysql -uroot -p${ROOT_PASS} -e"GRANT FILE ON * . * TO '${DB_USER}'@'${DB_HOST}';"

    if [ -f $SQL_DIR/mst_table_struct.sql ]; then
        cd $SQL_DIR
        # tb=`myserver.sql|sed 's/[\n\r\t\v]//g'`
        /usr/local/mysql/bin/mysql -u${DB_USER} -p${DB_PASS} ${DB_NAME}<mst_table_struct.sql
        wait
    else
        echo $SQL_DIR"/mst_table_struct.sql not found."
    fi

    if [ -f $SQL_DIR/base_admin_user_group.sql ]; then
        cd $SQL_DIR
        /usr/local/mysql/bin/mysql -u${DB_USER} -p${DB_PASS} ${DB_NAME}<base_admin_user_group.sql
        wait
    else
        echo $SQL_DIR"/mst_table_struct.sql not found."
    fi

    echo "create db user ${1} done"
}
