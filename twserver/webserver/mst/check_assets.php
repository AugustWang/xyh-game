<?php
//
// ############## 登陆前检测 ##############
//
// 客户端每次登陆之前，必须先请求：
//
// 开发：http://42.121.111.191/mst/check_assets.php?p=平台标识&v=当前版本号&a=资源版本号
// 发布：http://42.62.14.78/mst/check_assets.php?p=平台标识&v=当前版本号&a=资源版本号
//
// 参数说明：
// p = platform
// v = version
// a = assets version
//
// 响应格式：ok 或者 param|value
//
// param ：error / update_assets
//
// 例：
//
// 正常响应：ok
// 错误信息：error|平台ID无效
// 更新数据：update_assets|http://assets.szturbotech.com/mst/assets/

header("Content-type: text/html; charset=utf-8");

if (!isset($_GET['v'])) exit('error|no_version');
if (!isset($_GET['p'])) exit('error|no_platform');
if (!isset($_GET['a'])) exit('error|no_assets_version');

$v = $_GET['v'];
$p = $_GET['p'];
$a = $_GET['a'];

include('./common.php');

$platforms = include('./array_platforms.php');

if(isset($platforms[$p])){
    $platform = $platforms[$p];
    if($a < $platform['assets_version']){
        echo 'update_assets|'.$platform['assets_url'];
    }else{
        echo 'ok';
    }
}else{
    echo 'error|undef_platform';
}

access_log();
