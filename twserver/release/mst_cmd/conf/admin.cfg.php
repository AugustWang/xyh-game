<?php
/*-----------------------------------------------------+
 * 默认公共配置
 +-----------------------------------------------------*/
return array(
    'version' => 'VERSION', //版本
    'server_id' => 'SERVER_ID', //服务器ID
    'server_name' => '萌獸堂 SERVER_ID區',
    'server_host' => 'http://szturbotech.com', //服务器URL
    'server_host_ssl' => 'https://szturbotech.com', //服务器URL ssl
    'server_key' => 'abc',  //服务器使用的加密串
    //ERLANG服务器相关设定
    'erl' => array(
        'cookie' => '{COOKIE}',
        'node' => '{NODE}',
    ),
    //时区
    'timezone' => 'Asia/Shanghai',
    //会话失效时间
    'session_timeout' => 7200,
    //数据库服务器信息
    'database' => array(
        'driver' => 'mysql',
        'encode' => 'utf8',
        'host' => '{DB_HOST}',
        'user' => '{DB_USER}',
        'pass' => '{DB_PASS}',
        'dbname' => '{DB_NAME}'
    ),
    //用于验证的一些正则表达式
    're' => array(
        //角色名规则
        'name' => '/^[a-z0-9_]{3,20}$/'
    ),
);
