<?php

/*-----------------------------------------------------+
 * 菜单配置
 *
 * 注意：数据索引定义后不能进行修改，否则会引起权限混乱
 * 隐藏菜单：'hidden' => true
 *
 * @author rolong@vip.qq.com<rolong@vip.qq.com>
 +-----------------------------------------------------*/

return array(
    10 => array(
        'title' => '开发工具',
        'sub' => array(
            10 => array('title' => '导入表格数据', 'url' => '?mod=data&act=excel'),
            20 => array('title' => '导入地图数据', 'url' => '?mod=data&act=map'),
            30 => array('title' => '生成任务数据', 'url' => '?mod=data&act=task'),
            40 => array('title' => '协议生成工具', 'url' => '?mod=data&act=protocol'),
        ),
    ),
    90 => array(
        'title' => '系统设置',
        'sub' => array(
            10 => array('title' => '用户组管理',       'url' => '?mod=users&act=group_list'),
            20 => array('title' => '后台用户帐号管理', 'url' => '?mod=users&act=list'),
            30 => array('title' => '后台操作日志',     'url' => '?mod=log&act=admin'),
            40 => array('title' => '修改我的密码',     'url' => '?mod=users&act=set_password'),
        ),
    ),
);
