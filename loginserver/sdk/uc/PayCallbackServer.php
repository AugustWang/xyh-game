<?php
include_once 'Logging.php';
include_once 'Method/payCallback.php';

// 接收HTTP POST信息
$request = file_get_contents("php://input");
Logging::logFile("debug.log", "[PayCallbackServer.php]收到的支付回调的请求：".$request);

// 处理支付回调请求
$config = include('config.inc.php');
$obj = new payCallBack($config);
$result = $obj->payCallBackMethod($request);

echo $result;
?>