<?php

// 注意：数据索引定义后不能进行修改，否则会引起权限混乱
// 'hidden' => true

return array(
    10 => array(
        'title' => '订单管理',
        'sub' => array(
            10 => array('title' => '充值订单', 'url' => '?mod=charge&act=order'),
        ),
    ),
    90 => array(
        'title' => '系统设置',
        'sub' => array(
            10 => array('title' => '用户组管理', 'url' => '?mod=users&act=group_list'),
            20 => array('title' => '后台用户帐号管理', 'url' => '?mod=users&act=list'),
            30 => array('title' => '后台操作日志', 'url' => '?mod=log&act=admin'),
            40 => array('title' => '修改我的密码', 'url' => '?mod=users&act=set_password'),
        ),
    ),
);
