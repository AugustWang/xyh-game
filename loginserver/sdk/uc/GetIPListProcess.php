<?php
include "IPList.php";
include "Logging.php";
//获取ip列表入口
//运行此php定时获取IP列表【进程】：

 while(true){
 	$config = include('config.inc.php');
 	$ipListClass = new IPList();
    $ipListClass->getIPListMethod();
 	sleep(intval($config['intervalTime'])*60*60);//默认间隔一天
 }
?>