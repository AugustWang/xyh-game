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
            50 => array('title' => '生成补全数据', 'url' => '?mod=sheet&act=make_js'),
        ),
    ),
    20 => array(
        'title' => '运营操作',
        'sub' => array(
            10 => array('title' => '游戏返馈', 'url' => '?mod=feedback&act=list'),
            20 => array('title' => '游戏公告', 'url' => '?mod=feedback&act=notice'),
            30 => array('title' => '游戏公告-编辑','hidden' => true, 'url' =>'?mod=feedback&act=notice_edit'),
            31 => array('title' => '游戏公告-删除','hidden' => true, 'url' =>'?mod=feedback&act=notice_del'),
            40 => array('title' => '充值日志', 'url' => '?mod=log&act=charge'),
            60 => array('title' => '系统广播','hidden' => true, 'url' => '?mod=feedback&act=notice_sys'),
            79 => array('title' => '运营活动', 'url' => '?mod=feedback&act=operator'),
            80 => array('title' => '物品数据', 'url' => '?mod=feedback&act=log_item'),
            81 => array('title' => '金币数据', 'url' => '?mod=feedback&act=log_gold'),
            82 => array('title' => '钻石数据', 'url' => '?mod=feedback&act=log_diamond'),
            83 => array('title' => '邮件列表', 'url' => '?mod=feedback&act=mail_list'),
            84 => array('title' => '统计数据', 'url' => '?mod=feedback&act=data_all'),
            85 => array('title' => '英雄购买日志', 'url' => '?mod=feedback&act=log_hero'),
            86 => array('title' => '兑换码', 'url' => '?mod=feedback&act=activate'),
            87 => array('title' => '注册数据', 'url' => '?mod=feedback&act=register'),
            //88 => array('title' => '用户留存', 'url' => '?mod=feedback&act=retention2'),
            89 => array('title' => '收入总览', 'url' => '?mod=feedback&act=payer2'),
            90 => array('title' => '付费用户', 'url' => '?mod=feedback&act=payer'),
            91 => array('title' => '定期活动', 'hidden' => true, 'url' => '?mod=feedback&act=timeing'),
            92 => array('title' => '自定义活动', 'hidden' => true, 'url' => '?mod=feedback&act=custom'),
            93 => array('title' => '定期活动列表', 'url' => '?mod=feedback&act=check_timeing'),
            94 => array('title' => '自定义活动列表', 'url' => '?mod=feedback&act=check_custom'),
            //95 => array('title' => '生成数据', 'url' => '?mod=feedback&act=test_info'),
            //96 => array('title' => '生成数据', 'url' => '?mod=feedback&act=test_growth'),
            97 => array('title' => '额外活动', 'hidden' => true, 'url' => '?mod=feedback&act=extra'),
            98 => array('title' => '额外活动列表', 'url' => '?mod=feedback&act=check_extra'),
            //99 => array('title' => '停留统计test', 'url' => '?mod=feedback&act=statistic_growth'),
            100 => array('title' => '停留统计', 'url' => '?mod=feedback&act=statis_growth'),
            101 => array('title' => '宝珠数据', 'url' => '?mod=feedback&act=log_jewel'),
            102 => array('title' => '登录次数', 'url' => '?mod=feedback&act=login_count'),
            103 => array('title' => '定期活动日志', 'hidden' => true, 'url' => '?mod=feedback&act=log_activity'),
            104 => array('title' => '自定义活动日志', 'hidden' => true, 'url' => '?mod=feedback&act=log_custom'),
            105 => array('title' => '额外活动日志', 'hidden' => true, 'url' => '?mod=feedback&act=log_extra'),
            106 => array('title' => '兑换码统计', 'hidden' => true, 'url' => '?mod=feedback&act=log_activate'),
            107 => array('title' => '生成兑换码', 'hidden' => true, 'url' => '?mod=feedback&act=create_activate'),
            108 => array('title' => '留存统计', 'url' => '?mod=feedback&act=log_retention'),
            109 => array('title' => '战斗统计', 'url' => '?mod=feedback&act=log_combat'),
            110 => array('title' => 'm战斗统计', 'hidden' => true, 'url' => '?mod=feedback&act=log_combat1'),
            111 => array('title' => 'f战斗统计', 'hidden' => true, 'url' => '?mod=feedback&act=log_combat2'),
            112 => array('title' => 'e战斗统计', 'hidden' => true, 'url' => '?mod=feedback&act=log_combat3'),
            113 => array('title' => '付费行为', 'url' => '?mod=feedback&act=payer_action'),
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
            11 => array('target' => 'dialog', 'title' => 'DEBUG' , 'hidden' => true, 'url' => '?mod=role&act=send_info&cmd=1011'),
            12 => array('target' => 'dialog', 'title' => 'ITEM'  , 'hidden' => true, 'url' => '?mod=role&act=send_info&cmd=9010'),
            13 => array('target' => 'dialog', 'title' => 'HERO'  , 'hidden' => true, 'url' => '?mod=role&act=send_info&cmd=9012'),
            14 => array('target' => 'dialog', 'title' => 'RS'    , 'hidden' => true, 'url' => '?mod=role&act=send_info&cmd=9015'),
            15 => array('target' => 'dialog', 'title' => '清空数据', 'hidden' => true, 'url' => '?mod=role&act=send_info&cmd=9016'),

            16 => array('target' => 'dialog', 'title' => '送货币', 'hidden' => true, 'url' => '?mod=role&act=send_money'),
            17 => array('target' => 'dialog', 'title' => '送物品', 'hidden' => true, 'url' => '?mod=role&act=send_item'),
            18 => array('target' => 'dialog', 'title' => '加成就', 'hidden' => true, 'url' => '?mod=role&act=send_attain'),
            19 => array('target' => 'dialog', 'title' => '加疲劳', 'hidden' => true, 'url' => '?mod=role&act=send_power'),
            20 => array('target' => 'dialog', 'title' => '加经验', 'hidden' => true, 'url' => '?mod=role&act=add_heroes_exp'),
            21 => array('target' => 'dialog', 'title' => '通关'  , 'hidden' => true, 'url' => '?mod=role&act=send_info&cmd=2030'),
            22 => array('target' => 'dialog', 'title' => '设置关卡','hidden' => true, 'url' =>'?mod=role&act=send_tollgate'),
            23 => array('target' => 'dialog', 'title' => '踢'    , 'hidden' => true, 'url' => '?mod=role&act=kick'),
            24 => array('target' => 'dialog', 'title' => '送英雄','hidden' => true, 'url' =>'?mod=role&act=send_hero'),
            25 => array('target' => 'dialog', 'title' => '荣誉值','hidden' => true, 'url' =>'?mod=role&act=send_honor'),
            26 => array('target' => 'page',   'title' => '发邮件','hidden' => true, 'url' =>'?mod=role&act=send_email'),
            27 => array('target' => 'dialog', 'title' => '竞技次数重置','hidden' => true, 'url' =>'?mod=role&act=send_info&cmd=2026'),
         // 28 => array('target' => 'dialog', 'title' => '送经验','hidden' => true, 'url' =>'?mod=role&act=send_exp'),
            29 => array('target' => 'dialog', 'title' => '送vip','hidden' => true, 'url' =>'?mod=role&act=send_vip'),
            30 => array('target' => 'dialog', 'title' => '新密码','hidden' => true, 'url' =>'?mod=role&act=reset_passwd'),
            31 => array('target' => 'dialog', 'title' => '发短信','hidden' => true, 'url' =>'?mod=role&act=send_verify'),
            32 => array('target' => 'dialog', 'title' => '扣除','hidden' => true, 'url' =>'?mod=role&act=send_deduct'),
            33 => array('target' => 'dialog', 'title' => '成长','hidden' => true, 'url' => '?mod=role&act=send_growth'),
            34 => array('target' => 'dialog', 'title' => '月卡','hidden' => true, 'url' => '?mod=role&act=send_mcard'),
            35 => array('target' => 'dialog', 'title' => '补单','hidden' => true, 'url' => '?mod=role&act=send_buy'),
            36 => array('target' => 'dialog', 'title' => '补签','hidden' => true, 'url' => '?mod=role&act=send_info&cmd=2077'),

            60 => array('target' => 'page',   'title' => '金币流', 'hidden' => true, 'url' => '?mod=role&act=gold_list'),
            61 => array('target' => 'page',   'title' => '钻石流', 'hidden' => true, 'url' => '?mod=role&act=diamond_list'),
            62 => array('target' => 'page',   'title' => '强化日志','hidden' => true, 'url' => '?mod=log&act=enhance'),
            63 => array('target' => 'page',   'title' => '成就','hidden' => true, 'url' => '?mod=role&act=check_attain'),
            64 => array('target' => 'page',   'title' => '荣誉流','hidden' => true, 'url' => '?mod=role&act=honor_list'),
            65 => array('target' => 'page',   'title' => '充值日志','hidden' => true, 'url' =>'?mod=log&act=charge'),
            66 => array('target' => 'page',   'title' => '英雄列表','hidden' => true, 'url' =>'?mod=role&act=check_heroes'),
            67 => array('target' => 'page',   'title' => '物品列表','hidden' => true, 'url' =>'?mod=role&act=check_items'),
            68 => array('target' => 'page',   'title' => '物品流','hidden' => true, 'url' =>'?mod=role&act=item_list'),
            69 => array('target' => 'page',   'title' => '签到','hidden' => true, 'url' =>'?mod=role&act=check_sign'),
            70 => array('target' => 'page',   'title' => '金币图','hidden' => true, 'url' =>'?mod=role&act=gold_view'),
            71 => array('target' => 'page',   'title' => '钻石图','hidden' => true, 'url' =>'?mod=role&act=diamond_view'),
            72 => array('target' => 'page',   'title' => '任务列表','hidden' => true, 'url' =>'?mod=role&act=task_list'),
            73 => array('target' => 'page',   'title' => '幸运星','hidden' => true, 'url' =>'?mod=role&act=luck_list'),
            74 => array('target' => 'page',   'title' => '雇佣兵','hidden' => true, 'url' =>'?mod=role&act=check_gatehero'),
            75 => array('target' => 'page',   'title' => '净化','hidden' => true, 'url' =>'?mod=role&act=check_purge'),
            76 => array('target' => 'page',   'title' => '升星','hidden' => true, 'url' =>'?mod=role&act=check_star'),
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
            62 => array('title' => '钻石流分布', 'url' => '?mod=statistic&act=diamond'),
            63 => array('title' => '金币流分布', 'url' => '?mod=statistic&act=gold'),
            70 => array('title' => '商城购买分布', 'url' => '?mod=statistic&act=shop'),
            80 => array('title' => '每日购买分布', 'url' => '?mod=statistic&act=shopday'),
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
