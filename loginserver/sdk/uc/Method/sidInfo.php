<?php
class sidInfo{

	/**
	 * sid用户会话验证。
	 * @param sid 从游戏客户端的请求中获取的sid值
	 */
	public function sidInfoMethod($sid){
		Logging::logFile('debug.log',"[sidInfo.php]"."[开始调用sidInfo接口]");
		$service = "ucid.user.sidInfo";
		$dataParam = array();
		$dataParam['sid']			= $sid;//在uc sdk登录成功时，游戏客户端通过uc sdk的api获取到sid，再游戏客户端由传到游戏服务器
        $ap = new AccessProxy();
		$result = $ap->postProxy($service,$dataParam);//http post方式调用服务器接口,请求的body内容是参数json格式字符串
		Logging::logFile('debug.log',"[sidInfo.php]"."[响应结果]".$result);
		$responseData = json_decode($result,true);//结果也是一个json格式字符串
        print_r($responseData);
		if($responseData!=null){//反序列化成功，输出其对象内容
			Logging::logFile('debug.log',"[sidInfo.php]"."[id]:".$responseData['id']);
			Logging::logFile('debug.log',"[sidInfo.php]"."[code]:".$responseData['state']['code']);
			Logging::logFile('debug.log',"[sidInfo.php]"."[msg]:".$responseData['state']['msg']);
			Logging::logFile('debug.log',"[sidInfo.php]"."[ucid]:".$responseData['data']['ucid']);
			Logging::logFile('debug.log',"[sidInfo.php]"."[nickname]:".$responseData['data']['nickname']);
		}else{
			Logging::logFile('debug.log',"[sidInfo.php]"."[data]:"."[sidInfo接口返回异常]");
			throw new Exception("[sidInfo接口返回异常]");
		}
		Logging::logFile('debug.log',"[sidInfo.php]"."[调用sidInfo接口结束]");
	}
}
