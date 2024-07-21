<?php

// 更新流程：
// 先修改mst_update_url
// 再修改版本号

return array(
    10001 => array(
        'name'    => '测试服',                ## 服务器名称
        'ip'      => '42.121.111.191',         ## IP
        'port'    => '8100',                   ## 端口
        'version' => '1.4.0',                  ## 版本号
        'status'  => 1,                        ## 1=正常,2=火爆,3=维护中,4=新区,5=等待开启
        'info'    => '',
    ),
    10002 => array(
        'name'    => '1区体验服',
        'ip'      => '183.232.32.39',
        'port'    => '8100',
        'version' => '1.4.0',
        'status'  => 2,
        'info'    => '',
    ),
    1 => array(
        'name'    => '运营1服',
        'ip'      => '112.124.14.215',
        'port'    => '8100',
        'version' => '1.4.0',
        'status'  => 2,
        'info'    => '',
    ),
    2 => array(
        'name'    => '2区黑曜石',
        'ip'      => '112.124.14.215',
        'port'    => '8300',
        'version' => '1.4.0',
        'status'  => 5,
        'info'    => '萌亲,6月23日10:00安卓版首发,记得那天过来哦,萌兽等你来战!',
    ),
    100 => array(
        'name'    => '1区铁炉堡',            ## android 1区服务器
        'ip'      => '42.62.67.188',
        'port'    => '8100',
        'version' => '1.4.0',
        'status'  => 5,
        'info'    => '萌亲,6月23日10:00安卓版首发,记得那天过来哦,萌兽等你来战!',
    ),
    1000 => array(
        'name'    => '2区苹果审核',
        'ip'      => '183.232.32.39',
        'port'    => '8300',
        'version' => '1.4.0',
        'status'  => 5,
        'info'    => '萌亲,6月23日10:00安卓版首发,记得那天过来哦,萌兽等你来战!',
    ),
    10003 => array(
        'name'    => '开发服',
        'ip'      => '192.168.0.8',
        'port'    => '8100',
        'version' => '1.4.0',
        'status'  => 2,
        'info'    => '',
    ),
    10005 => array(
        'name'    => '汪飘华',
        'ip'      => '192.168.0.202',
        'port'    => '8100',
        'version' => '1.3.0',
        'status'  => 4,
        'info'    => '',
    ),
    10006 => array(
        'name'    => '钟瑞仙',
        'ip'      => '192.168.0.129',
        'port'    => '8100',
        'version' => '1.1.1',
        'status'  => 3,
        'info'    => '萌亲,该区维护中...',
    ),
);
