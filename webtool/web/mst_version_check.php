<?php
// 版本检测
//
// 客户端每次登陆之前，必须先请求：
//
// http://42.121.111.191/mst_version_check.php?p=平台标识&s=服务器标识&v=当前版本号
//
// 参数说明：
// p = platform
// s = server
// v = version
//
// 如：http://42.121.111.191/mst_version_check?p=ios&s=10001&v=1.4.0
//
// 响应：
// 正常：ok
// 错误：error|平台ID无效
// 维护：close|服务器维护中，预计12:00开放，敬请关注！
// 更新：update|https://itunes.apple.com/cn/app/meng-shou-tang/id785823993?mt=8
//
// 维护时，须用提示框弹出后面的内容
// 更新时，须弹出更新提示，并在确认后跳转到后面的URL

if (!isset($_GET['v'])) exit('error|no_version');
if (!isset($_GET['p'])) exit('error|no_platform');
if (!isset($_GET['s'])) exit('error|no_server_id');

$v = $_GET['v'];
$p = $_GET['p'];
$s = $_GET['s'];

$servers = include('./mst_servers.php');

if(isset($servers[$s])){
    $server = $servers[$s];
    if($server['version'] == $v){
        if($server['status'] == 3 || $server['status'] == 5){
            echo 'close|'.$server['info'];
        }else{
            echo 'ok';
        }
    }else{
        $platforms = include('./mst_update_url.php');
        if(isset($platforms[$p])){
            echo 'update|'.$platforms[$p];
        }else{
            echo 'update|http://szturbotech.com';
        }
    }
}
