<?php

// 更新流程：
// 先修改mst_update_url
// 再修改版本号

// 'name'    ## 服务器名称
// 'ip'      ## IP
// 'port'    ## 端口
// 'version' ## 版本号
// 'status'  ## 1=正常,2=火爆,3=维护中,4=新区,5=等待开启
// 'info'    ## 提示文字
//
// status: 1=正常,2=火爆,3=维护中,4=新区,5=等待开启

return array(
    200 => array(
        'name'    => '繁体测试服',            ## 台湾服务器
        'ip'      => '211.72.249.246',
        'port'    => '8401',
        'version' => '1.6.0',
        'status'  => 1,
        // 'info'    => '萌亲,该区维护中,预计在17点开放',
        'info'    => '',
    ),
    201 => array(
        'name'    => '1区 怒焰裂谷',            ## 台湾服务器
        'ip'      => '211.72.249.247',
        'port'    => '8001',
        'version' => '1.6.0',
        'status'  => 2,
        // 'info'    => '萌亲,该区维护中,预计在12点开放',
        /// 'info'    => '萌亲,该区维护中,10:00准时开启',
        'info'    => '',
    ),
);
