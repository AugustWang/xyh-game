<?php
class ucidBindCreate{	
	/**
	 * ucid和游戏官方帐号绑定接口。
	 * @param gameUser 游戏官方帐号
	 */
	public function ucidBindCreateMethod($gameUser){
		Logging::logFile('debug.log',"[ucidBindCreate.php]"."[开始调用ucid和游戏官方账号绑定接口]");
		///////////////////////////////////////////////////
		$dataParam = array();
		$dataParam['gameUser']		= $gameUser;//游戏官方帐号
		$service="ucid.bind.create"; 
		$ap = new AccessProxy();
		$result = $ap->postProxy($service,$dataParam);//http post方式调用服务器接口,请求的body内容是参数json格式字符串
		Logging::logFile('debug.log',"[ucidBindCreate.php]"."[响应结果]".$result);
		$responseData = json_decode($result,true);//结果也是一个json格式字符串
		if($responseData!=null){//反序列化成功，输出其对象内容
			Logging::logFile('debug.log',"[ucidBindCreate.php]"."[id]:".$responseData['id']);
			Logging::logFile('debug.log',"[ucidBindCreate.php]"."[code]:".$responseData['state']['code']);
			Logging::logFile('debug.log',"[ucidBindCreate.php]"."[msg]:".$responseData['state']['msg']);
			Logging::logFile('debug.log',"[ucidBindCreate.php]"."[ucid]:".$responseData['data']['ucid']);
			Logging::logFile('debug.log',"[ucidBindCreate.php]"."[sid]:".$responseData['data']['sid']);
		}else{
			Logging::logFile('debug.log',"[ucidBindCreate.php]"."[接口返回异常]");
			throw new Exception("[接口返回异常]");
		}
		Logging::logFile('debug.log',"[ucidBindCreate.php]"."[调用ucid和游戏官方账号绑定接口结束]");
	}
}
