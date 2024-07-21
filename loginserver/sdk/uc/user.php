<?php
include "pc_Shm.php";
include "AccessProxy.php";
include "Logging.php";
include "Method/sidInfo.php";
include "Method/ucidBindCreate.php";

$config = include('config.inc.php');
/////////////////////////////////////////////////
try{
    if(!isset($_GET['sid'])) return;
    $sid = $_GET['sid'];
    $service = "ucid.user.sidInfo";
    $dataParam = array();
    $dataParam['sid']			= $sid;//在uc sdk登录成功时，游戏客户端通过uc sdk的api获取到sid，再游戏客户端由传到游戏服务器
    $ap = new AccessProxy();
    $result = $ap->postProxy($service,$dataParam);//http post方式调用服务器接口,请求的body内容是参数json格式字符串
    print_r($result);

    //			$gameUser = "abcd";//request.Params["gameUser"];从游戏客户端的请求中获取的gameUser值
    //			$ucidClass = new ucidBindCreate($this->config);//调用ucid和游戏官方帐号绑定接口
    //			$ucidClass->ucidBindCreateMethod($gameUser);	
}catch(Exception $e){
    Logging::logFile('debug.log',"[getUserInfo.php]".$e->getMessage());
}
