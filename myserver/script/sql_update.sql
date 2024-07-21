-- 2013.11.04 16:25
DROP TABLE IF EXISTS `log_reg`;
CREATE TABLE IF NOT EXISTS `log_reg` (
  `id` int(50) NOT NULL COMMENT '角色ID',
  `aid` varchar(255) NOT NULL COMMENT '帐号ID',
  `ctime` int(11) unsigned NOT NULL,
  `ip` char(15) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aid` (`aid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='注册日志';

-- 2013.11.04 16:28
ALTER TABLE `log_reg` ADD INDEX ( `ctime` );


-- 2013.11.18 10:37
CREATE TABLE IF NOT EXISTS `rank_luck` (
  `id` int(11) NOT NULL COMMENT 'ID',
  `name` varchar(50) NOT NULL COMMENT '名字',
  `use_sum` int(11) NOT NULL COMMENT '',
  `val_sum` int(11) NOT NULL COMMENT '',
  `reward_id` int(11) NOT NULL COMMENT '',
  `reward_num` int(11) NOT NULL COMMENT '',
  `ctime` int(11) NOT NULL COMMENT '',
  PRIMARY KEY (`id`,`ctime`),
  KEY `val_sum` (`val_sum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='';

-- 2013.11.20 10:37
ALTER TABLE`arena`ADD`power` INT( 11)NOT NULL DEFAULT'0' COMMENT'战斗力' AFTER`exp` ;

-- 2013.11.22 10:37
DROP TABLE IF EXISTS `log_login`;
CREATE TABLE `log_login` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '角色id',
  `event` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '事件：0=登录,1=正常退出,2＝系统关闭时被迫退出,3＝被动退出,4＝其它情况导致的退出',
  `first` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `login_day` int(11) unsigned NOT NULL DEFAULT '0',
  `login_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '时间',
  `logout_time` int(11) unsigned NOT NULL DEFAULT '0',
  `ip` char(15) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`),
  KEY `event` (`event`),
  KEY `first` (`first`),
  KEY `login_day` (`login_day`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `log_reg_num`;
CREATE TABLE `log_reg_num` (
  `day` int(11) NOT NULL COMMENT '注册日期（unixstamp）',
  `date` int(11) NOT NULL COMMENT '注册日期（20131122）',
  `num` int(11) NOT NULL COMMENT '注册人数',
  PRIMARY KEY (`day`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='注册人数';

DROP TABLE IF EXISTS `log_retention`;
CREATE TABLE `log_retention` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `reg_date` int(11) unsigned NOT NULL COMMENT '注册日期',
  `reg_day` int(11) unsigned NOT NULL,
  `reg_num` int(11) unsigned NOT NULL,
  `login_num` int(11) unsigned NOT NULL,
  `nth_day` tinyint(3) unsigned NOT NULL COMMENT '第X天留存率',
  `rate` tinyint(3) unsigned NOT NULL COMMENT '留存率',
  PRIMARY KEY (`id`),
  KEY `reg_time` (`reg_day`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COMMENT='留存率日志';

DROP TABLE IF EXISTS `tmp_login`;
CREATE TABLE `tmp_login` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `tmp_reg`;
CREATE TABLE `tmp_reg` (
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- 2013.11.27
CREATE TABLE IF NOT EXISTS `log_economy` (
  `day_stamp` int(10) unsigned NOT NULL COMMENT '每天0点时间戳',
  `mon_date` int(10) unsigned NOT NULL COMMENT '月份（如201311）',
  `gold_add` int(10) unsigned NOT NULL COMMENT '当天金币总产出',
  `gold_sub` int(10) unsigned NOT NULL COMMENT '当天金币总消耗',
  `diamond_add` int(10) unsigned NOT NULL COMMENT '当天钻石总产出',
  `diamond_sub` int(10) unsigned NOT NULL COMMENT '当天钻石总消耗',
  PRIMARY KEY (`day_stamp`),
  KEY `mon_stamp` (`mon_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


-- 2013/12/03 周二
--
-- 表的结构 `log_diamond`
--

DROP TABLE IF EXISTS `log_diamond`;
CREATE TABLE IF NOT EXISTS `log_diamond` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `role_id` int(11) unsigned NOT NULL COMMENT '角色ID',
  `type` int(11) unsigned NOT NULL COMMENT '类型',
  `num` int(11) NOT NULL COMMENT '数量',
  `rest` int(11) unsigned NOT NULL COMMENT '剩余',
  `ctime` int(10) unsigned NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='钻石流动日志';

-- --------------------------------------------------------

--
-- 表的结构 `log_gold`
--

DROP TABLE IF EXISTS `log_gold`;
CREATE TABLE IF NOT EXISTS `log_gold` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `role_id` int(11) unsigned NOT NULL COMMENT '角色ID',
  `type` int(11) unsigned NOT NULL COMMENT '类型',
  `num` int(11) NOT NULL COMMENT '数量',
  `rest` int(11) unsigned NOT NULL COMMENT '剩余',
  `ctime` int(10) unsigned NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='金币流动日志';


-- 2014-01-08
-- 表的结构 `log_shop_num`
--

CREATE TABLE IF NOT EXISTS `log_shop_num` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shop_id` int(11) NOT NULL,
  `day_stamp` int(10) unsigned NOT NULL COMMENT '购买日期（unixstamp）',
  `mon_date` int(10) unsigned NOT NULL COMMENT '购买月份(201401)',
  `num` int(10) unsigned NOT NULL COMMENT '购买数量',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='商城购买统计日志' AUTO_INCREMENT=1 ;


-- 生成日期: 2014 年 01 月 21 日 01:25
-- 表的结构 `activity`
--

CREATE TABLE IF NOT EXISTS `activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `verify` int(11) NOT NULL COMMENT '邀请激活码',
  `activityinfo` blob NOT NULL COMMENT '活动列表信息',
  `friends` blob NOT NULL COMMENT '好友列表',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='活动信息数据' AUTO_INCREMENT=1 ;

-- 生成日期: 2014 年 02 月 15 日
-- 表的结构 `email`
--

CREATE TABLE IF NOT EXISTS `email` (
  `email_id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `from_id` int(11) NOT NULL COMMENT '发件人id',
  `from` varchar(50) DEFAULT NULL COMMENT '邮件发件人',
  `content` varchar(500) DEFAULT NULL COMMENT '邮件内容',
  `enclosure` blob NOT NULL COMMENT '邮件附件列表',
  `ctime` int(11) NOT NULL,
  PRIMARY KEY (`email_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='邮件' AUTO_INCREMENT=1 ;

-- 生成日期: 2014 年 03 月 07 日
-- 更新表 `role`
--

ALTER TABLE  `role` ADD  `combat` INT( 11 ) UNSIGNED NOT NULL COMMENT  '战斗力' AFTER  `tollgate_id` ;

-- 生成日期: 2014 年 03 月 10 日
-- 更新表 `arena`
--

ALTER TABLE  `arena` ADD  `newlev` TINYINT( 2 ) UNSIGNED NOT NULL DEFAULT  '1' COMMENT  '新段位' AFTER  `exp`;
ALTER TABLE  `arena` ADD  `newexp` INT( 11 ) UNSIGNED NOT NULL DEFAULT  '0' COMMENT  '新荣誉值' AFTER  `newlev`;

ALTER TABLE  `arena` CHANGE  `newlev`  `newlev` TINYINT( 2 ) UNSIGNED NOT NULL DEFAULT  '1' COMMENT  '新段位';
ALTER TABLE  `arena` ADD  `newreport` BLOB NOT NULL COMMENT  '新战报' AFTER  `report`;
ALTER TABLE  `arena` ADD  `warnum` INT( 11 ) UNSIGNED NOT NULL COMMENT  '战斗次数' AFTER  `newexp`;

-- 生成日期: 2014 年 03 月 17 日
-- 表的结构 `pictorial`
--

CREATE TABLE IF NOT EXISTS `pictorial` (
  `role_id` int(10) unsigned NOT NULL,
  `pictorial` blob NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='图鉴';
