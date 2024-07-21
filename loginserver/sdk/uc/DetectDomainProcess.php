<?php
include "DetectDomain.php";
include "Logging.php";
//检测域名【入口】，运行此php可定时检测域名可用行.

 while(true){
 	$config = include('config.inc.php');
 	$detectDomainClass = new DetectDomain();
    $detectDomainClass->detectDomainAvailable();
 	sleep(intval($config['checkTime']));//，默认间隔10秒检测
 }
?>