SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;


CREATE TABLE `activate_key` (
  `key` varchar(50) NOT NULL COMMENT '激活码',
  `type` int(4) unsigned NOT NULL DEFAULT '1' COMMENT '奖励类型id',
  `time` int(11) unsigned NOT NULL,
  `role_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '使用该激活码的id',
  PRIMARY KEY (`key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='活动激活码';

CREATE TABLE `activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `verify` int(11) NOT NULL COMMENT '邀请激活码',
  `activityinfo` blob NOT NULL COMMENT '活动列表信息',
  `friends` blob NOT NULL COMMENT '好友列表',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='活动信息数据';

CREATE TABLE `admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_name` varchar(20) NOT NULL COMMENT '管理员名称',
  `event` tinyint(2) NOT NULL COMMENT '1登录',
  `ctime` int(10) NOT NULL COMMENT '创建时间',
  `ip` varchar(15) NOT NULL COMMENT 'IP',
  `memo` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `admin_name` (`admin_name`,`ctime`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='后台管理日志';

CREATE TABLE `app_store` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(10) unsigned NOT NULL,
  `transaction_id` varchar(100) NOT NULL,
  `product_id` varchar(100) NOT NULL,
  `purchase_date` varchar(15) NOT NULL,
  `bvrs` varchar(10) NOT NULL,
  `platform` int(4) unsigned NOT NULL DEFAULT '0',
  `diamond` int(10) unsigned NOT NULL,
  `rmb` int(11) unsigned NOT NULL,
  `ctime` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`,`transaction_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='app_store购买记录';

CREATE TABLE `arena` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `robot` tinyint(1) NOT NULL COMMENT '是否为机器人(1=是,2=是,0=否)',
  `rid` int(11) NOT NULL COMMENT '玩家ID',
  `lev` tinyint(2) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `newlev` tinyint(2) unsigned NOT NULL DEFAULT '1' COMMENT '新段位',
  `newexp` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '新荣誉值',
  `warnum` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '战斗次数',
  `highrank` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '历史最高排名',
  `prizetime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '领取荣誉时间',
  `index` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '关闭服务时排名',
  `power` int(11) NOT NULL DEFAULT '0' COMMENT '战斗力',
  `picture` tinyint(1) NOT NULL COMMENT '头像',
  `name` varchar(255) NOT NULL COMMENT '名字',
  `rival` blob COMMENT '对手信息',
  `report` blob COMMENT '战报列表',
  `newreport` blob COMMENT '新战报',
  `s` blob COMMENT '英雄',
  `ctime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '退出时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `robot` (`robot`,`rid`),
  KEY `lev` (`lev`),
  KEY `name` (`name`),
  KEY `exp` (`exp`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

CREATE TABLE `attain` (
  `id` int(11) NOT NULL,
  `ctime` int(11) NOT NULL,
  `attain` blob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `base_admin_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL COMMENT '登录名',
  `status` tinyint(1) unsigned NOT NULL COMMENT '激活状态',
  `passwd` varchar(32) NOT NULL COMMENT '密码(md5)',
  `name` varchar(20) NOT NULL COMMENT '真实姓名',
  `description` text NOT NULL COMMENT '描述',
  `last_visit` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `last_ip` varchar(15) DEFAULT NULL COMMENT '最后登录点IP',
  `last_addr` varchar(30) DEFAULT NULL COMMENT '最后登录地点',
  `login_times` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '登录次数',
  `group_id` smallint(3) NOT NULL COMMENT '所属用户组ID',
  `ip_limit` varchar(150) NOT NULL DEFAULT ' ',
  `error_ip` char(15) NOT NULL DEFAULT '' COMMENT '出错的ip',
  `error_time` int(10) NOT NULL DEFAULT '0' COMMENT '出错时间',
  `error_num` tinyint(2) NOT NULL DEFAULT '0' COMMENT '出错次数',
  `members` varchar(150) NOT NULL DEFAULT ' ' COMMENT '属下成员后台登录名称',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='后台管理员帐号';

CREATE TABLE `base_admin_user_group` (
  `id` smallint(3) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL COMMENT '用户组名称',
  `menu` text NOT NULL COMMENT '菜单权限id,,',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='后台用户组';

CREATE TABLE `client_info` (
  `role_id` int(11) NOT NULL,
  `key` int(11) NOT NULL,
  `value` varchar(500) DEFAULT NULL COMMENT '内容',
  PRIMARY KEY (`role_id`,`key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='客户端存储';

CREATE TABLE `email` (
  `email_id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `from_id` int(11) NOT NULL COMMENT '发件人id',
  `type_id` int(4) unsigned NOT NULL DEFAULT '0' COMMENT '奖励类型id',
  `from` varchar(50) DEFAULT NULL COMMENT '邮件发件人',
  `content` varchar(500) DEFAULT NULL COMMENT '邮件内容',
  `enclosure` blob NOT NULL COMMENT '邮件附件列表',
  `ctime` int(11) NOT NULL,
  PRIMARY KEY (`email_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='邮件';

CREATE TABLE `fb_info` (
  `role_id` int(10) unsigned NOT NULL,
  `fb_info` blob NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='副本信息存储';

CREATE TABLE `feedback` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(10) unsigned NOT NULL,
  `type` tinyint(1) unsigned NOT NULL,
  `ctime` int(10) unsigned NOT NULL,
  `ip` varchar(20) NOT NULL,
  `aid` varchar(100) NOT NULL,
  `content` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

CREATE TABLE `fun_data` (
  `role_id` int(10) unsigned NOT NULL,
  `fun_data` blob NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='功能开放状态';

CREATE TABLE `gatehero` (
  `role_id` int(11) NOT NULL COMMENT '玩家id',
  `hid` blob NOT NULL COMMENT '金币购买的英雄序号列表',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `hero` (
  `role_id` int(11) NOT NULL,
  `hero_id` int(11) NOT NULL,
  `val` blob NOT NULL,
  PRIMARY KEY (`role_id`,`hero_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `herosoul` (
  `role_id` int(11) NOT NULL COMMENT '角色id',
  `herosoul` blob NOT NULL COMMENT '英雄魂数据',
  PRIMARY KEY (`role_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='英雄魂命运之门';

CREATE TABLE `item` (
  `role_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `val` blob NOT NULL,
  PRIMARY KEY (`role_id`,`item_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `jewel` (
  `role_id` int(10) unsigned NOT NULL,
  `jewel` tinyblob NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='宝珠获取状态';

CREATE TABLE `log_active_num` (
  `day` int(11) NOT NULL,
  `date` int(11) NOT NULL,
  `num` int(11) NOT NULL,
  PRIMARY KEY (`day`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `log_activity_stat` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` int(11) NOT NULL COMMENT '活动key',
  `start_time` int(11) unsigned NOT NULL COMMENT '活动开始时间',
  `end_time` int(11) unsigned NOT NULL COMMENT '活动结束时间',
  `send_list` blob NOT NULL COMMENT '要发送的列表',
  `use_list` blob NOT NULL COMMENT '已接收的列表',
  `body` varchar(500) DEFAULT NULL COMMENT '邮件内容',
  `items` blob NOT NULL COMMENT '邮件附件列表',
  `count` int(11) unsigned NOT NULL COMMENT '当天接收人数',
  `ctime` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='邮件活动任务统计';

CREATE TABLE `log_add_item` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `role_id` int(11) unsigned NOT NULL COMMENT '角色ID',
  `type` int(8) unsigned NOT NULL COMMENT '1=掉落/2=合成/..',
  `tid` int(11) unsigned NOT NULL COMMENT '物品ID',
  `num` int(10) unsigned NOT NULL COMMENT '数量',
  `ctime` int(10) unsigned NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='物品流动日志';

CREATE TABLE `log_combat` (
  `role_id` int(11) NOT NULL,
  `tollgate_id` int(11) NOT NULL,
  `num` int(11) NOT NULL COMMENT '数量',
  `ctime` int(10) unsigned NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`role_id`,`tollgate_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `log_combine` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `tid` int(11) NOT NULL COMMENT '物品类型ID',
  `ctime` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='合成日志';

CREATE TABLE `log_custom_stat` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` int(11) NOT NULL COMMENT '活动key',
  `start_time` int(11) unsigned NOT NULL COMMENT '活动开始时间',
  `end_time` int(11) unsigned NOT NULL COMMENT '活动结束时间',
  `val` blob NOT NULL COMMENT '活动条件列表',
  `use_list` blob NOT NULL COMMENT '已接收的列表',
  `body` varchar(500) DEFAULT NULL COMMENT '邮件内容',
  `items` blob NOT NULL COMMENT '邮件附件列表',
  `count` int(11) unsigned NOT NULL COMMENT '当天接收人数',
  `ctime` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='自定义活动任务统计';

CREATE TABLE `log_del_item` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `role_id` int(11) unsigned NOT NULL COMMENT '角色ID',
  `type` int(8) unsigned NOT NULL COMMENT '1=出售/2=吞噬/..',
  `tid` int(11) unsigned NOT NULL COMMENT '物品ID',
  `num` int(10) unsigned NOT NULL COMMENT '数量',
  `ctime` int(10) unsigned NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='物品流动日志';

CREATE TABLE `log_diamond` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `role_id` int(11) unsigned NOT NULL COMMENT '角色ID',
  `type` int(11) unsigned NOT NULL COMMENT '类型',
  `num` int(11) NOT NULL COMMENT '数量',
  `rest` int(11) unsigned NOT NULL COMMENT '剩余',
  `ctime` int(10) unsigned NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='钻石流动日志';

CREATE TABLE `log_economy` (
  `day_stamp` int(10) unsigned NOT NULL COMMENT '每天0点时间戳',
  `mon_date` int(10) unsigned NOT NULL COMMENT '月份（如201311）',
  `gold_add` int(10) unsigned NOT NULL COMMENT '当天金币总产出',
  `gold_sub` int(10) unsigned NOT NULL COMMENT '当天金币总消耗',
  `diamond_add` int(10) unsigned NOT NULL COMMENT '当天钻石总产出',
  `diamond_sub` int(10) unsigned NOT NULL COMMENT '当天钻石总消耗',
  PRIMARY KEY (`day_stamp`),
  KEY `mon_stamp` (`mon_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='经济流动统计日志';

CREATE TABLE `log_embed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `equ_id` int(11) NOT NULL,
  `jewel_id` int(11) NOT NULL,
  `ctime` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='镶嵌日志';

CREATE TABLE `log_enhance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `tid` int(11) NOT NULL,
  `lev` int(11) NOT NULL,
  `status` tinyint(1) unsigned NOT NULL COMMENT '1=成功,0=失败',
  `ctime` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='强化日志';

CREATE TABLE `log_extra_stat` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` int(11) NOT NULL COMMENT '活动key',
  `type` varchar(20) NOT NULL COMMENT '活动类型',
  `start_time` int(11) unsigned NOT NULL COMMENT '活动开始时间',
  `end_time` int(11) unsigned NOT NULL COMMENT '活动结束时间',
  `val` blob NOT NULL COMMENT '活动条件列表',
  `use_list` blob NOT NULL COMMENT '已接收的列表',
  `body` varchar(500) DEFAULT NULL COMMENT '邮件内容',
  `items` blob NOT NULL COMMENT '邮件附件列表',
  `count` int(11) unsigned NOT NULL COMMENT '当天接收人数',
  `ctime` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='额外活动任务统计';

CREATE TABLE `log_forge` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `tid` int(11) NOT NULL COMMENT '合成装备ID',
  `ctime` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='合成日志';

CREATE TABLE `log_gold` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `role_id` int(11) unsigned NOT NULL COMMENT '角色ID',
  `type` int(11) unsigned NOT NULL COMMENT '类型',
  `num` int(11) NOT NULL COMMENT '数量',
  `rest` int(11) unsigned NOT NULL COMMENT '剩余',
  `ctime` int(10) unsigned NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='金币流动日志';

CREATE TABLE `log_hero` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `hero_id` int(11) NOT NULL,
  `quality` int(8) NOT NULL,
  `ctime` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`),
  KEY `shop_id` (`hero_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='英雄购买日志';

CREATE TABLE `log_honor` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `role_id` int(11) unsigned NOT NULL COMMENT '角色ID',
  `tid` int(11) unsigned NOT NULL COMMENT '物品ID,1=战斗获得,2=领取奖励获得,3=后台加送',
  `num` int(11) NOT NULL COMMENT '当前荣誉',
  `rest` int(11) unsigned NOT NULL COMMENT '剩余荣誉',
  `ctime` int(10) unsigned NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='荣誉日志';

CREATE TABLE `log_jewel` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `tid` int(11) NOT NULL,
  `ctime` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='宝珠获得日志';

CREATE TABLE `log_login` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '角色id',
  `event` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '事件：0=登录,1=正常退出,2＝系统关闭时被迫退出,3＝被动退出,4＝其它情况导致的退出',
  `day_stamp` int(11) unsigned NOT NULL DEFAULT '0',
  `login_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
  `logout_time` int(11) unsigned NOT NULL DEFAULT '0',
  `ip` char(15) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`),
  KEY `event` (`event`),
  KEY `day_stamp` (`day_stamp`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

CREATE TABLE `log_login_times` (
  `ctime` int(10) NOT NULL COMMENT '创建时间',
  `json` text NOT NULL COMMENT '各个等级人数json',
  PRIMARY KEY (`ctime`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='每天登录次数统计表';

CREATE TABLE `log_online_num` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time_stamp` int(10) NOT NULL DEFAULT '0' COMMENT '统计时间',
  `day_stamp` int(11) NOT NULL COMMENT '日期（天）',
  `num` smallint(5) NOT NULL COMMENT '在线人数',
  PRIMARY KEY (`id`),
  KEY `num` (`num`),
  KEY `day_stamp` (`day_stamp`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='在线人数统计';

CREATE TABLE `log_online_time` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL COMMENT '角色ID',
  `otime` int(10) NOT NULL COMMENT '当天在线时间累计',
  `ctime` int(10) NOT NULL COMMENT '本记录创建时间',
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`),
  KEY `ctime` (`ctime`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `log_online_top` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ctime` int(10) NOT NULL COMMENT '时间',
  `num` mediumint(6) NOT NULL COMMENT '在线人数',
  PRIMARY KEY (`id`),
  KEY `ctime` (`ctime`,`num`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='按日期记录当天最高在线';

CREATE TABLE `log_payment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created` int(11) NOT NULL,
  `shop_id` int(11) NOT NULL,
  `count` int(11) NOT NULL,
  `pf_money` varchar(200) NOT NULL,
  `pf_uid` varchar(200) NOT NULL,
  `pf_order_id` varchar(200) NOT NULL,
  `msg` varchar(2000) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pf_order_id` (`pf_order_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `log_reg` (
  `id` int(50) NOT NULL COMMENT '角色ID',
  `aid` varchar(255) NOT NULL COMMENT '帐号ID',
  `ctime` int(11) unsigned NOT NULL,
  `day_stamp` int(11) NOT NULL,
  `day_date` int(11) NOT NULL,
  `ip` char(15) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aid` (`aid`),
  KEY `day_date` (`day_date`),
  KEY `day_stamp` (`day_stamp`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='注册日志';

CREATE TABLE `log_reg_num` (
  `day` int(11) NOT NULL COMMENT '注册日期（unixstamp）',
  `date` int(11) NOT NULL COMMENT '注册日期（20131122）',
  `num` int(11) NOT NULL COMMENT '注册人数',
  PRIMARY KEY (`day`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='注册人数';

CREATE TABLE `log_retention` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `reg_date` int(11) unsigned NOT NULL COMMENT '注册日期',
  `reg_stamp` int(11) unsigned NOT NULL,
  `reg_num` int(11) unsigned NOT NULL,
  `login_num` int(11) unsigned NOT NULL,
  `nth_day` tinyint(3) unsigned NOT NULL COMMENT '第X天留存率',
  `rate` tinyint(3) unsigned NOT NULL COMMENT '留存率',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COMMENT='留存率日志';

CREATE TABLE `log_shop` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `shop_id` int(11) NOT NULL,
  `ctime` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`),
  KEY `shop_id` (`shop_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='商城购买日志';

CREATE TABLE `log_shop_num` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shop_id` int(11) NOT NULL,
  `day_stamp` int(10) unsigned NOT NULL COMMENT '购买日期（unixstamp）',
  `mon_date` int(10) unsigned NOT NULL COMMENT '购买月份(201401)',
  `num` int(10) unsigned NOT NULL COMMENT '购买数量',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='商城购买统计日志';

CREATE TABLE `log_upgrade` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(10) NOT NULL COMMENT '角色ID',
  `lev` tinyint(3) unsigned NOT NULL COMMENT '新等级',
  `ctime` int(10) NOT NULL COMMENT '升级时间',
  `msg` varchar(255) DEFAULT NULL COMMENT '升级消息',
  PRIMARY KEY (`id`),
  KEY `role` (`role_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='角色升级日志表';

CREATE TABLE `log_user_stat` (
  `day_stamp` int(10) unsigned NOT NULL COMMENT '注册日期（unixstamp）',
  `day_date` int(10) unsigned NOT NULL COMMENT '注册日期（20131122）',
  `mon_date` int(10) unsigned NOT NULL,
  `reg_num` int(10) unsigned NOT NULL COMMENT '注册人数',
  `active_num` int(10) unsigned NOT NULL COMMENT '活跃人数',
  `online_num` int(10) unsigned NOT NULL COMMENT '在线人数',
  PRIMARY KEY (`day_stamp`),
  KEY `mon_date` (`mon_date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='用户每日注册&活跃&登陆统计';

CREATE TABLE `paydouble` (
  `role_id` int(10) unsigned NOT NULL,
  `paydouble` tinyblob NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='支付双倍';

CREATE TABLE `pictorial` (
  `role_id` int(10) unsigned NOT NULL,
  `pictorial` blob NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='图鉴';

CREATE TABLE `rank_luck` (
  `id` int(11) NOT NULL COMMENT 'ID',
  `name` varchar(50) NOT NULL COMMENT '名字',
  `use_sum` int(11) NOT NULL,
  `val_sum` int(11) NOT NULL,
  `reward_id` int(11) NOT NULL,
  `reward_num` int(11) NOT NULL,
  `ctime` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `val_sum` (`val_sum`),
  KEY `ctime` (`ctime`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `role` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `gold` int(11) unsigned NOT NULL DEFAULT '0',
  `diamond` int(11) unsigned NOT NULL DEFAULT '0',
  `diamond_sum` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '总钻石数',
  `lev` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `tollgate_id` smallint(5) unsigned NOT NULL DEFAULT '1' COMMENT '关卡ID',
  `tollgate_newid` smallint(5) unsigned NOT NULL DEFAULT '1' COMMENT '新关卡ID',
  `combat` int(11) NOT NULL DEFAULT '0',
  `sid` int(16) unsigned NOT NULL DEFAULT '10002' COMMENT '服务器ID',
  `platform` varchar(20) NOT NULL DEFAULT 'windows' COMMENT '平台标识',
  `aid` varchar(64) NOT NULL,
  `name` varchar(64) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `verify_code` int(6) NOT NULL DEFAULT '0' COMMENT '短信验证码',
  `verify_time` int(11) NOT NULL DEFAULT '0' COMMENT '验证码发送时间',
  `ctime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '注册时间',
  `login_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '最后登陆时间',
  `kvs` blob NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aid` (`aid`,`password`),
  KEY `tollgate_id` (`tollgate_id`),
  KEY `ctime` (`ctime`),
  KEY `login_time` (`login_time`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='角色数据';

CREATE TABLE `sign` (
  `role_id` int(10) unsigned NOT NULL,
  `sign` tinyblob NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='登录连续签到';

CREATE TABLE `sys_notices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(4) unsigned NOT NULL DEFAULT '0',
  `time` int(4) unsigned NOT NULL DEFAULT '0',
  `msg` varchar(2000) NOT NULL,
  `start_time` int(11) NOT NULL,
  `end_time` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `start_time` (`start_time`),
  KEY `end_time` (`end_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `task` (
  `id` int(11) NOT NULL,
  `task` blob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tavern` (
  `role_id` int(11) NOT NULL COMMENT '角色ID',
  `tavern_time` int(11) NOT NULL,
  `tavern` blob NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='英雄酒馆数据';

CREATE TABLE `test` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bin` varbinary(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `tmp_login` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `tmp_reg` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `tollgate_sta` (
  `id` int(11) unsigned NOT NULL COMMENT '关卡',
  `num` int(11) unsigned NOT NULL COMMENT '人数',
  `lost_num` int(11) unsigned NOT NULL COMMENT '流失人数',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='关卡分布统计';

CREATE TABLE `tollgate_sta_new` (
  `id` int(11) unsigned NOT NULL COMMENT '关卡',
  `num` int(11) unsigned NOT NULL COMMENT '人数',
  `lost_num` int(11) unsigned NOT NULL COMMENT '流失人数',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='关卡分布统计';

CREATE TABLE `vip` (
  `role_id` int(10) unsigned NOT NULL,
  `vip` blob NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='vip';

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
