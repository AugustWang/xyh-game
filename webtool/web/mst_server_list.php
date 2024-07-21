<?php

// 每次打开服务器列表界面时，都必须重新请求:
//
// http://42.121.111.191/mst_server_list.php
//
// 服务器名称 | 服务器ID | IP | 端口 | 状态 | 提示消息
//
// 注意：这里没有版本号和更新地址
//
// 如果提示消息不为空，点击时须用对话框弹出提示消息，并且不能进入游戏
//
// status: 1=正常,2=火爆,3=维护中,4=新区,5=等待开启
// 注意：这五种状态，必须有5种状态角标，而且不能出现灰掉不可点的情况
//       状态3或5时，后面必须有提示内容，
//       而且点击确定之后，必须重新请求mst_server_list.php，防止停留在这一界面永不重新请求的情况出现

function get_server_list($serverIds){
    $servers = include('./mst_servers.php');
    $list = array();
    foreach($serverIds as $sid){
        $s = $servers[$sid];
        $list[] = "{$s['name']}|{$sid}|{$s['ip']}|{$s['port']}|{$s['status']}|{$s['info']}";
    }
    return implode("\n", $list);
}

if ($_GET['p'] == 'ios') {
    echo get_server_list(array('10001', '10003'));
}else{
    echo get_server_list(array('10001', '10003'));
}
