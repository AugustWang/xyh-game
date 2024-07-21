<?php

// 每次打开服务器列表界面时，都必须重新请求服务器列表数据:
//
// http://42.62.14.78/mst/servers.php?p=平台标识&v=当前版本号
//
// 服务器名称 | 服务器ID | IP | 端口 | 状态 | 提示消息
//
// 状态: 1=正常,2=火爆,3=维护中,4=新区,5=等待开启
// 注意：这五种状态，必须有5种状态角标，而且不能出现灰掉不可点的情况，
//       状态3或5时，后面必须有提示内容，而且点击确定之后，
//       必须重新请求mst_server_list.php，
//       防止停留在这一界面永不重新请求的情况出现
//
// 如果[提示消息]不为空，点击时用对话框弹出[提示消息]，并且不能进入游戏
//
// 注意：这里没有版本号和更新地址

header("Content-type: text/html; charset=utf-8");

if (!isset($_GET['v'])) exit('error|no_version');
if (!isset($_GET['p'])) exit('error|no_platform');

include('./define.php');
include('./common.php');

$v = $_GET['v'];
$p = $_GET['p'];

if ($p == 'windows' || $v == '9.9.9') {
    echo get_server_list(DEV_SERVER_IDS);
}else {
    if(check_version($v, UNION_RELEASE_VERSION) <= 0){
        echo get_server_list(UNION_RELEASE_SERVER_IDS);
    }else{
        echo get_server_list(UNION_CHECK_SERVER_IDS);
    }
}

access_log();
