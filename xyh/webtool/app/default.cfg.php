<?php
/*-----------------------------------------------------+
 * 默认公共配置
 +-----------------------------------------------------*/
return array(
    'version' => '', //版本
    'server_id' => '1', //服务器ID
    'server_name' => '萌兽堂',
    'server_host' => 'http://szturbotech.com', //服务器URL
    'server_host_ssl' => 'https://szturbotech.com', //服务器URL ssl
    'server_key' => 'abc',  //服务器使用的加密串
    //ERLANG服务器相关设定
    'erl' => array(
        'cookie' => 'myserver0755',
        'node' => 'myserver1@127.0.0.1',
    ),
    //时区
    'timezone' => 'Asia/Shanghai',
    //会话失效时间
    'session_timeout' => 7200,
    //数据库服务器信息
    'database' => array(
        'driver' => 'mysql',
        'encode' => 'utf8',
        'host' => '127.0.0.1',
        'user' => 'dolotech',
        'pass' => 'dolotech',
        'dbname' => 'xyh'
    ),
    //用于验证的一些正则表达式
    're' => array(
        //角色名规则
        'name' => '/^[a-z0-9_]{3,20}$/'
    ),
);
