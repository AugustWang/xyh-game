<?php

## 成就完成推送
$protocol[24001] = array(
    'name' => 'attain_send',
    'c2s' => array(
    ),
    's2c' => array(
        'id'   => 'int32',	# 成就ID
    ),
);

## 领取成就
$protocol[24004] = array(
    'name' => 'attain_get',
    'c2s' => array(
        'id' => 'int32', # 成就id
    ),
    's2c' => array(
        # 消息代码：
        # Code:
        # 0 = 成功
        # 3 = 背包已满
        # >=127 = 程序异常
        'code' => 'int8',
        'id' => 'int16',	# 成就id  =0:已经全部完成
        'type' => 'int8',	# 0=未完成,1=可以领取
    ),
);

## 成就初始化
$protocol[24006] = array(
    'name' => 'attain_init',
    'c2s' => array(
    ),
    's2c' => array(
        'ids'  => array(
            '_obj_name' => 'AttainInfo',
            'id' => 'int32',
            'num' => 'int32',   # 完成数量
            'type' => 'int8',	# 0=未完成,1=可以领取
        ),
    ),
);
