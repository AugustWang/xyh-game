<?php
//
// ############## 登陆前检测 ##############
//
// 客户端每次登陆之前，必须先请求：
//
// http://118.192.91.108/mst/check.php?p=平台标识&s=服务器标识&v=当前版本号&d=数据版本号
//
// 参数说明：
// p = platform
// s = server
// v = version
// d = data version
//
// 如：http://118.192.91.108/mst/check?p=ios&s=10001&v=1.4.0&d=20
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
// 更新数据：update_data|http://42.121.111.191/assets_20/
//
// 注：
// 停服维护时，用提示框弹出close的值
// 更新游戏时，弹出更新提示，并在确认后跳转到update_game的值(URL)

header("Content-type: text/html; charset=utf-8");

if (!isset($_GET['v'])) exit('error|no_version');
if (!isset($_GET['p'])) exit('error|no_platform');
if (!isset($_GET['s'])) exit('error|no_server_id');
if (!isset($_GET['d'])) exit('error|no_data_version');

$v = $_GET['v'];
$p = $_GET['p'];
$s = $_GET['s'];
$d = $_GET['d'];

include('./common.php');

$servers = include('./array_servers.php');

if(isset($servers[$s])){
    $server = $servers[$s];
    if(check_version($v, $server['version']) >= 0){
        if($server['status'] == 3 || $server['status'] == 5){
            echo 'close|'.$server['info'];
        }else{
            // if($d < $server['data_version']){
            //     if ($p == 'windows') {
            //         echo 'update_data|http://42.121.111.191/assets/';
            //     }else {
            //         echo 'update_data|http://42.121.111.191/assets/';
            //     }
            // }else{
            //     echo 'ok';
            // }
            echo 'ok';
        }
    }else{
        $platforms = include('./array_platforms.php');
        if(isset($platforms[$p]['download_url'])){
            echo 'update_game|'.$platforms[$p]['download_url'];
        }else{
            echo 'update_game|http://mst.szturbotech.com';
        }
    }
}else{
    echo 'error|undef_server';
}

access_log();
