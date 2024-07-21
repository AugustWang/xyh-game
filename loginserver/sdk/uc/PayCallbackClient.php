<?php
include_once 'Logging.php';
include_once 'HttpClient.php';

/**
 * 支付回调通知模拟客户端。
 */
class PayCallbackClient {
    
    function postPayCallback($serverUrl) {
        $requestString = '{"sign":"6f2648fc1f194d46f46da622fba35eb1","data":{"failedDesc":"","amount":"30.0","callbackInfo":"serverip=sgall#channel=502#user=288287224.uc","ucid":"10000","gameId":"1","payWay":"1","serverId":"1132","orderStatus":"S","orderId":"20120312113248863160"}}';
        Logging::logFile("debug.log", "发送支付回调的请求信息：".$requestString);
        $result = HttpClient::quickPost($serverUrl,$requestString);
		return $result;
    }
    
}

// 接收支付回调的服务器接口地址（注：CP根据的支付回调接口修改）
$serverUrl = "http://118.192.91.108/charge.php?mod=callback&act=uc";

$client = new PayCallbackClient();
$result = $client->postPayCallback($serverUrl);
Logging::logFile("debug.log", "发送支付回调的响应信息：".$result);
?>
