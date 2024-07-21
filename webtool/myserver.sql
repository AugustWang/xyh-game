-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- 主机: 127.0.0.1
-- 生成日期: 2013 年 09 月 26 日 09:19
-- 服务器版本: 5.5.25-log
-- PHP 版本: 5.2.17p1

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- 数据库: `myserver`
--

-- --------------------------------------------------------

--
-- 表的结构 `admin_log`
--

CREATE TABLE IF NOT EXISTS `admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_name` varchar(20) NOT NULL COMMENT '管理员名称',
  `event` tinyint(2) NOT NULL COMMENT '1登录',
  `ctime` int(10) NOT NULL COMMENT '创建时间',
  `ip` varchar(15) NOT NULL COMMENT 'IP',
  `memo` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `admin_name` (`admin_name`,`ctime`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='后台管理日志' AUTO_INCREMENT=912 ;

-- --------------------------------------------------------

--
-- 表的结构 `base_admin_user`
--

CREATE TABLE IF NOT EXISTS `base_admin_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL COMMENT '登录名',
  `status` tinyint(1) unsigned NOT NULL COMMENT '激活状态',
  `passwd` varchar(32) NOT NULL COMMENT '密码(md5)',
  `name` varchar(20) NOT NULL COMMENT '真实姓名',
  `description` text NOT NULL COMMENT '描述',
  `last_visit` int(10) unsigned NOT NULL COMMENT '最后登录时间',
  `last_ip` varchar(15) NOT NULL COMMENT '最后登录点IP',
  `last_addr` varchar(30) NOT NULL COMMENT '最后登录地点',
  `login_times` int(10) unsigned NOT NULL COMMENT '登录次数',
  `group_id` smallint(3) NOT NULL COMMENT '所属用户组ID',
  `ip_limit` varchar(150) NOT NULL DEFAULT ' ',
  `error_ip` char(15) NOT NULL DEFAULT '' COMMENT '出错的ip',
  `error_time` int(10) NOT NULL DEFAULT '0' COMMENT '出错时间',
  `error_num` tinyint(2) NOT NULL DEFAULT '0' COMMENT '出错次数',
  `members` varchar(150) NOT NULL DEFAULT ' ' COMMENT '属下成员后台登录名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='后台管理员帐号' AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- 表的结构 `base_admin_user_group`
--

CREATE TABLE IF NOT EXISTS `base_admin_user_group` (
  `id` smallint(3) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL COMMENT '用户组名称',
  `menu` text NOT NULL COMMENT '菜单权限id,,',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='后台用户组' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `hero`
--

CREATE TABLE IF NOT EXISTS `hero` (
  `role_id` int(11) NOT NULL,
  `hero_id` int(11) NOT NULL,
  `val` blob NOT NULL,
  PRIMARY KEY (`role_id`,`hero_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `item`
--

CREATE TABLE IF NOT EXISTS `item` (
  `role_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `val` blob NOT NULL,
  PRIMARY KEY (`role_id`,`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `role`
--

CREATE TABLE IF NOT EXISTS `role` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `gold` int(11) unsigned NOT NULL DEFAULT '0',
  `diamond` int(11) unsigned NOT NULL DEFAULT '0',
  `essence` int(11) unsigned NOT NULL DEFAULT '0',
  `lev` tinyint(3) unsigned NOT NULL,
  `tollgate_id` smallint(5) unsigned NOT NULL DEFAULT '1' COMMENT '关卡ID',
  `aid` varchar(64) NOT NULL,
  `name` varchar(64) NOT NULL,
  `kvs` blob NOT NULL,
  `f1` int(3) DEFAULT '1' COMMENT 'abc',
  PRIMARY KEY (`id`),
  KEY `lev` (`lev`,`aid`,`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='角色数据' AUTO_INCREMENT=12 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
