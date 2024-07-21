<?php

// 注意：数据索引定义后不能进行修改，否则会引起权限混乱
// 'hidden' => true

return array(
    10 => array(
        'title' => '开发工具',
        'sub' => array(
            10 => array('title' => 'Excel数据导入', 'url' => '?mod=sheet&act=from_excel'),
            20 => array('title' => 'Erlang控制终端', 'url' => '?mod=erlang&act=ctl'),
            30 => array('title' => '生成通信协议', 'url' => '?mod=protocol&act=update'),
            40 => array('title' => '查看通信协议', 'url' => '?mod=protocol&act=list'),
        ),
    ),
    20 => array(
        'title' => '运营操作',
        'sub' => array(
            10 => array('title' => '游戏返馈', 'url' => '?mod=feedback&act=list'),
            20 => array('title' => '游戏公告', 'url' => '?mod=feedback&act=notice'),
            30 => array('title' => '游戏公告-编辑','hidden' => true, 'url' =>'?mod=feedback&act=notice_edit'),
            40 => array('title' => '充值日志', 'url' => '?mod=log&act=charge'),
            60 => array('title' => '系统广播', 'url' => '?mod=feedback&act=notice_sys'),
            80 => array('title' => '运营活动', 'url' => '?mod=feedback&act=operator'),
            87 => array('title' => '注册数据', 'url' => '?mod=feedback&act=register'),
            //88 => array('title' => '用户留存', 'url' => '?mod=feedback&act=retention2'),
            89 => array('title' => '收入总览', 'url' => '?mod=feedback&act=payer2'),
            90 => array('title' => '付费用户', 'url' => '?mod=feedback&act=payer'),
            91 => array('title' => '定期活动', 'url' => '?mod=feedback&act=timeing'),
            92 => array('title' => '自定义活动', 'url' => '?mod=feedback&act=custom'),
            93 => array('title' => '定期活动列表', 'url' => '?mod=feedback&act=check_timeing'),
            94 => array('title' => '自定义活动列表', 'url' => '?mod=feedback&act=check_custom'),
        ),
    ),
    30 => array(
        'title' => '角色管理',
        'sub'	=> array(
            10 => array('title' => '角色列表', 'url' => '?mod=role&act=list'),
            20 => array('title' => '在线列表', 'url' => '?mod=role&act=online'),
        ),
    ),
    32 => array(
        'title' => 'GM操作', // 对指定的角色进行GM操作，请求时必须转入角色ID
        'sub'	=> array(
            11 => array('title' => '送货币', 'hidden' => true, 'url' => '?mod=role&act=send_money'),
            12 => array('title' => '送物品', 'hidden' => true, 'url' => '?mod=role&act=send_item'),
            13 => array('title' => '加成就', 'hidden' => true, 'url' => '?mod=role&act=send_attain'),
            14 => array('title' => '加疲劳', 'hidden' => true, 'url' => '?mod=role&act=send_power'),
            15 => array('title' => '加经验', 'hidden' => true, 'url' => '?mod=role&act=add_heroes_exp'),
            16 => array('title' => '通关'  , 'hidden' => true, 'url' => '?mod=role&act=send_info&cmd=2030'),
            17 => array('title' => 'DEBUG' , 'hidden' => true, 'url' => '?mod=role&act=send_info&cmd=1011'),
            18 => array('title' => 'ITEM'  , 'hidden' => true, 'url' => '?mod=role&act=send_info&cmd=9010'),
            19 => array('title' => 'HERO'  , 'hidden' => true, 'url' => '?mod=role&act=send_info&cmd=9012'),
            20 => array('title' => '金币流', 'hidden' => true, 'url' => '?mod=role&act=gold_list'),
            21 => array('title' => '钻石流', 'hidden' => true, 'url' => '?mod=role&act=diamond_list'),
            22 => array('title' => '强化日志','hidden' => true, 'url' => '?mod=log&act=enhance'),
            23 => array('title' => 'RS'    , 'hidden' => true, 'url' => '?mod=role&act=send_info&cmd=9015'),
            24 => array('title' => '踢'    , 'hidden' => true, 'url' => '?mod=role&act=kick'),
            25 => array('title' => '设置关卡','hidden' => true, 'url' =>'?mod=role&act=send_tollgate'),
            26 => array('title' => '清空数据', 'hidden' => true, 'url' => '?mod=role&act=send_info&cmd=9016'),
            27 => array('title' => '送英雄','hidden' => true, 'url' =>'?mod=role&act=send_hero'),
            28 => array('title' => '荣誉值','hidden' => true, 'url' =>'?mod=role&act=send_honor'),
            29 => array('title' => '充值日志','hidden' => true, 'url' =>'?mod=log&act=charge'),
            30 => array('title' => '发邮件','hidden' => true, 'url' =>'?mod=role&act=send_email'),
            31 => array('title' => '竞技次数重置','hidden' => true, 'url' =>'?mod=role&act=send_info&cmd=2026'),
            // 32 => array('title' => '送经验','hidden' => true, 'url' =>'?mod=role&act=send_exp'),
            33 => array('title' => '送vip','hidden' => true, 'url' =>'?mod=role&act=send_vip'),
            34 => array('title' => '新密码','hidden' => true, 'url' =>'?mod=role&act=reset_passwd'),
            35 => array('title' => '发短信','hidden' => true, 'url' =>'?mod=role&act=send_verify'),
            36 => array('title' => '扣除','hidden' => true, 'url' =>'?mod=role&act=send_deduct'),
            37 => array('title' => '成就','hidden' => true, 'url' => '?mod=role&act=check_attain'),
            38 => array('title' => '荣誉流','hidden' => true, 'url' => '?mod=role&act=honor_list'),
            39 => array('title' => '成长','hidden' => true, 'url' => '?mod=role&act=send_growth'),
            40 => array('title' => '月卡','hidden' => true, 'url' => '?mod=role&act=send_mcard'),
            41 => array('title' => '补单','hidden' => true, 'url' => '?mod=role&act=send_buy'),
        ),
    ),
    40 => array(
        'title' => '统计图表',
        'sub' => array(
            10 => array('title' => '在线峰值统计', 'url' => '?mod=statistic&act=online_top'),
            20 => array('title' => '实时注册统计', 'url' => '?mod=statistic&act=reg'),
            30 => array('title' => '用户留存统计', 'url' => '?mod=statistic&act=retention'),
            40 => array('title' => '注册&活跃&在线', 'url' => '?mod=statistic&act=user'),
            50 => array('title' => '货币流通统计', 'url' => '?mod=statistic&act=economy'),
            60 => array('title' => '关卡人数分布', 'url' => '?mod=statistic&act=tollgate'),
            61 => array('title' => '关卡人数分布2', 'url' => '?mod=statistic&act=tollgate2'),
            70 => array('title' => '商城购买分布', 'url' => '?mod=statistic&act=shop'),
            80 => array('title' => '今天购买分布', 'url' => '?mod=statistic&act=shopday'),
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
