<?php

if (!isset($_GET['version'])) exit('No Version');

// function writeFile($file,$str,$mode='w')
// {
//     $oldmask = @umask(0);
//     $fp = @fopen($file,$mode);
//     @flock($fp, 3);
//     if(!$fp)
//     {
//         Return false;
//     }
//     else
//     {
//         @fwrite($fp,$str);
//         @fclose($fp);
//         @umask($oldmask);
//         Return true;
//     }
// }
//
// function writeGetUrlInfo()
// {
//
//     //获取请求方的地址，客户端，请求的页面及参数
//     $requestInformation = '['.date('Y-m-d H:i:s').'] '.$_SERVER['REMOTE_ADDR'].', '.$_SERVER['HTTP_USER_AGENT'].', http://'.$_SERVER['HTTP_HOST'].htmlentities($_SERVER['PHP_SELF']).'?'.$_SERVER['QUERY_STRING']."\n";
//     $fileName = './server_list.txt';
//     writeFile($fileName, $requestInformation, 'a'); //表示追加
// }
//
// writeGetUrlInfo();

// 注意：顺序不能改变

$list = array(
    // array(
    //     'name'    => '测试服',                 ## 服务器名称
    //     'sid'     => 10001,                    ## sid [10000,~]表示测试服务器,[1,99]表示ios正式服,[100,200]表示android正式服,[1000,9999]表示审核
    //     'ip'      => '42.121.111.191',         ## IP
    //     'port'    => '8100',                   ## 端口
    //     'url'     => 'https://itunes.apple.com/cn/app/meng-shou-tang/id785823993?mt=8', ## 更新地址
    //     'version' => '1.4.0',                  ## 版本号
    //     'status'  => 1,                        ## 1=正常,2=火爆,3=维护中,4=新区,5=等待开启
    //     'info'    => '',
    // ),
    array(
        'name'    => '1区体验服',
        'sid'     => 10002,
        'ip'      => '183.232.32.39',
        'port'    => '8100',
        'url'     => 'https://itunes.apple.com/cn/app/meng-shou-tang/id785823993?mt=8', ## 更新地址
        'version' => '1.4.0',
        'status'  => 2,
        'info'    => '',
    ),
    array(
        'name'    => '开发服',
        'sid'     => 10003,
        'ip'      => '192.168.0.8',
        'port'    => '8100',
        'url'     => 'https://itunes.apple.com/cn/app/meng-shou-tang/id785823993?mt=8', ## 更新地址
        'version' => '1.4.0',
        'status'  => 2,
        'info'    => '',
    ),
    array(
        'name'    => '汪飘华',
        'sid'     => 10005,
        'ip'      => '192.168.1.108',
        'port'    => '8100',
        'url'     => 'https://itunes.apple.com/cn/app/meng-shou-tang/id785823993?mt=8', ## 更新地址
        'version' => '1.4.0',
        'status'  => 4,
        'info'    => '',
    ),
    array(
        'name'    => '钟瑞仙',
        'sid'     => 10006,
        'ip'      => '192.168.0.129',
        'port'    => '8100',
        'url'     => 'https://itunes.apple.com/cn/app/meng-shou-tang/id785823993?mt=8', ## 更新地址
        'version' => '1.1.1',
        'status'  => 3,
        'info'    => '萌亲,该区维护中...',
    ),
    //array(
    //    'name'    => '1区洛丹伦',              ## ios 1区服务器
    //    'sid'     => 1,
    //    'ip'      => '112.124.14.215',
    //    'port'    => '8100',
    //    'url'     => 'https://itunes.apple.com/cn/app/meng-shou-tang/id785823993?mt=8', ## 更新地址
    //    'version' => '1.4.0',
    //    'status'  => 2,
    //    'info'    => '',
    //),
    //array(
    //    'name'    => '2区黑曜石',            ## ios 2区服务器
    //    'sid'     => 2,
    //    'ip'      => '112.124.14.215',
    //    'port'    => '8300',
    //    'url'     => 'https://itunes.apple.com/cn/app/meng-shou-tang/id785823993?mt=8', ## 更新地址
    //    'version' => '1.4.0',
    //    'status'  => 2,
    //    'info'    => '',
    //),
    //array(
    //    'name'    => '1区铁炉堡',            ## android 1区服务器
    //    'sid'     => 100,
    //    'ip'      => '42.62.67.188',
    //    'port'    => '8100',
    //    'url'     => 'https://itunes.apple.com/cn/app/meng-shou-tang/id785823993?mt=8', ## 更新地址
    //    'version' => '1.4.0',
    //    'status'  => 5,
    //    'info'    => '萌亲,6月23日10:00安卓版首发,记得那天过来哦,萌兽等你来战!',
    //),
    //array(
    //    'name'    => '2区苹果审核',          ## ios 审核中转服务器
    //    'sid'     => 1000,
    //    'ip'      => '183.232.32.39',
    //    'port'    => '8300',
    //    'url'     => 'https://itunes.apple.com/cn/app/meng-shou-tang/id785823993?mt=8', ## 更新地址
    //    'version' => '1.4.0',
    //    'status'  => 5,
    //    'info'    => '萌亲,6月23日10:00安卓版首发,记得那天过来哦,萌兽等你来战!',
    //),
);

// 服务器名称 | 服务器ID | IP | 端口 | 更新地址 | 版本号 | 状态 | 提示字符

$server_list = array();
foreach ($list as $row){
    $server_list[] = implode('|', $row);
}

echo implode("\n", $server_list);
