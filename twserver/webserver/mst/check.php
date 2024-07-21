<?php
//
// ############## 登陆前检测 ##############
//
// 客户端每次登陆之前，必须先请求：
//
// http://118.192.91.108/mst/check.php?p=平台标识&s=服务器标识&v=当前版本号
//
// 参数说明：
// p = platform
// s = server
// v = version
//
// 如：http://118.192.91.108/mst/check?p=ios&s=10001&v=1.4.0
//
// 响应格式：ok 或者 param|value
//
// param ：error / close / update_game / update_data
//
// 例：
//
// 正常响应：ok
// 错误信息：error|平台ID无效
// 停服维护：close|服务器维护中，预计12:00开放，敬请关注！
// 更新游戏：update_game|https://itunes.apple.com/cn/app/meng-shou-tang/id785823993?mt=8
//
// 注：
// 停服维护时，用提示框弹出close的值
// 更新游戏时，弹出更新提示，并在确认后跳转到update_game的值(URL)

header("Content-type: text/html; charset=utf-8");
include('./common.php');

if (!isset($_GET['v'])) {
    access_log("no_version\n");
    exit('error|no_version');
}
if (!isset($_GET['p'])) {
    access_log("no_platform\n");
    exit('error|no_platform');
}
if (!isset($_GET['s'])) {
    access_log("no_data_version\n");
    exit('error|no_server_id');
}

$v = $_GET['v'];
$p = $_GET['p'];
$s = $_GET['s'];

$servers = include('./array_servers.php');

if(isset($servers[$s])){
    $server = $servers[$s];
    if(check_version($v, $server['version']) >= 0){
        if($server['status'] == 3 || $server['status'] == 5){
            echo 'close|'.$server['info'];
        }else{
            echo 'ok';
        }
    }else{
        if($p == 'a_360' && check_version($v, '1.5.3') < 0){
            echo 'update_game|http://szturbotech.com/download.html';
        }else{
            $platforms = include('./array_platforms.php');
            if(isset($platforms[$p]['download_url'])){
                echo 'update_game|'.$platforms[$p]['download_url'];
            }else{
                echo 'update_game|http://mst.szturbotech.com';
            }
        }
    }
}else{
    // access_log("undef_server\n");
    // echo 'error|undef_server';
    echo 'ok';
}

access_log();
