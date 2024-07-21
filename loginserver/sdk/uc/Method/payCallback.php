<?php
class payCallBack{
	
	public $channelId;
	public $cpId;
	public $gameId;
	public $serverUrl;
	
	public function __construct($config){
		$this->config 		= $config;
		if(is_array($this->config)&& $this->config!=null){
			if(array_key_exists("serverUrl", $this->config)) 
				$this->serverUrl 	= $this->config['serverUrl'];
			if(array_key_exists("cpId", $this->config)) 
				$this->cpId 		= intval($this->config['cpId']);
			if(array_key_exists("gameId", $this->config)) 
				$this->gameId		= intval($this->config['gameId']);
			if(array_key_exists("channelId", $this->config)) 
				$this->channelId 	= intval($this->config['channelId']);
			if(array_key_exists("serverId", $this->config)) 
				$this->serverId 	= intval($this->config['serverId']);
			if(array_key_exists("apiKey", $this->config)) 
				$this->apiKey 		= $this->config['apiKey'];	
		}else{
			Logging::logFile("debug.log","[payCallBack.php]"."配置为空");
			throw new exception('配置为空');
		}
	}
	
	/**
	 * 支付回调通知。
	 * 注：
	 * 1.sdk server通过http post请求cp server的接口，cp server都要有一个响应，响应内容是payCallback函数的返回值
	 */
	public function payCallBackMethod($request){
		Logging::logFile("debug.log","[payCallBack.php]"."[接收到的参数]:".$request);
		try{
			$responseData = json_decode($request,true);
			if($responseData!=null){
				Logging::logFile("debug.log","[payCallBack.php]"."[sign]:".$responseData['sign']);
				Logging::logFile("debug.log","[payCallBack.php]"."[orderId]:".$responseData['data']['orderId']);
				Logging::logFile("debug.log","[payCallBack.php]"."[gameId]:".$responseData['data']['gameId']);
				Logging::logFile("debug.log","[payCallBack.php]"."[serverId]:".$responseData['data']['serverId']);
				Logging::logFile("debug.log","[payCallBack.php]"."[ucid]:".$responseData['data']['ucid']);
				Logging::logFile("debug.log","[payCallBack.php]"."[payWay]:".$responseData['data']['payWay']);
				Logging::logFile("debug.log","[payCallBack.php]"."[amount]:".$responseData['data']['amount']);
				Logging::logFile("debug.log","[payCallBack.php]"."[callbackInfo]:".$responseData['data']['callbackInfo']);
				Logging::logFile("debug.log","[payCallBack.php]"."[orderStatus]:".$responseData['data']['orderStatus']);
				Logging::logFile("debug.log","[payCallBack.php]"."[failedDesc]:".$responseData['data']['failedDesc']);
				/*
				假定cpId=109，apiKey=202cb962234w4ers2aaa

				sign的签名规则:data的所有子参数按key升序，key=value串接即
				      MD5(cpId + amount=...+callbackInfo=...+failedDesc=...+gameId=...+orderId=...
				               +orderStatus=...+payWay=...+serverId=...+ucid=...+apiKey)（去掉+；替换...为实际值）
				签名原文：
				109amount=100callbackInfo=aaafailedDesc=gameId=123orderId=abcf1330orderStatus=SpayWay=1serverId=654ucid=123456202cb962234w4ers2aaa
				*/
				$signSource = $this->cpId."amout=".$responseData['data']['amount']."callbackInfo=".$responseData['data']['callbackInfo']."failedDesc=".$responseData['data']['failedDesc']."gameId=".$responseData['data']['gameId']."orderId=".$responseData['data']['orderId']."orderStatus=".$responseData['data']['orderStatus']."payWay=".$responseData['data']['payWay']."serverId=".$responseData['data']['serverId']."ucid=".$responseData['data']['ucid'].$this->apiKey;
				$sign = md5($signSource);
				Logging::logFile("debug.log","[payCallBack.php]"."[签名原文]:".$signSource);
				Logging::logFile("debug.log","[payCallBack.php]"."[签名结果]:".$sign);
				if($sign == $responseData['sign']){
					/*
					* 游戏服务器需要处理给玩家充值代码,由游戏合作商开发完成。
					*/
					return 'SUCCESS';//返回给sdk server的响应内容 
				}else{
					return 'FAILURE';//返回给sdk server的响应内容 ,对于重复多次通知失败的订单,请参考文档中通知机制。
				}		
			}else{
				Logging::logFile("debug.log","[payCallBack.php]"."接口返回异常");
				throw new exception('接口返回异常');
			}
		}catch(Exception $e){
			Logging::logFile("debug.log","[payCallBack.php]".$e->getMessage());
			throw new exception($e->getMessage());
		}
		return 'FAILURE';//返回给sdk server的响应内容 ,对于重复多次通知失败的订单,请参考文档中通知机制。
	}
}