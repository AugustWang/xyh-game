-- phpMyAdmin SQL Dump
-- version 4.0.9
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2014-03-10 10:39:31
-- 服务器版本: 5.1.28-rc-community
-- PHP 版本: 5.2.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- 数据库: `xyh`
--
CREATE DATABASE IF NOT EXISTS `xyh` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `xyh`;

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
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='后台管理日志' AUTO_INCREMENT=11 ;

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='后台管理员帐号' AUTO_INCREMENT=2 ;

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
