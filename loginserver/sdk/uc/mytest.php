<?php
include "Logging.php";
include "Method/sidInfo.php";
include "Method/ucidBindCreate.php";

$config = include('config.inc.php');
Logging::logFile('debug.log',"[AppTest.php]"."[serverUrl]:".$config['serverUrl']);
Logging::logFile('debug.log',"[AppTest.php]"."[cpId]:".$config['cpId']);
Logging::logFile('debug.log',"[AppTest.php]"."[gameId]:".$config['gameId']);
Logging::logFile('debug.log',"[AppTest.php]"."[channelId]:".$config['channelId']);
Logging::logFile('debug.log',"[AppTest.php]"."[serverId]:".$config['serverId']);
Logging::logFile('debug.log',"[AppTest.php]"."[apiKey]:".$config['apiKey']);
/////////////////////////////////////////////////
try{
    $sid = "70b37f00-5f59-4819-99ad-8bde027ade00144882";//request.Params["sid"];从游戏客户端的请求中获取的sid值
    $sidClass = new sidInfo($this->config);
    $sidClass->sidInfoMethod($sid);

    //			$gameUser = "abcd";//request.Params["gameUser"];从游戏客户端的请求中获取的gameUser值
    //			$ucidClass = new ucidBindCreate($this->config);//调用ucid和游戏官方帐号绑定接口
    //			$ucidClass->ucidBindCreateMethod($gameUser);	
}catch(Exception $e){
    Logging::logFile('debug.log',"[AppTest.php]".$e->getMessage());
}
