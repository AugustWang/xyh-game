<?php
include "HttpClient.php";

//域名失效的控制处理逻辑类.
class AccessProxy {
	
	var $ipArray;
	
	/**
	 * 构造方法
	 */
	function AccessProxy(){
		$shm = new pc_Shm();
		$ipList = $shm->fetch('ipList');
		$this->ipArray = split(",",$ipList);
	}
	
	/**
	 * 访问代理方法
	 * @param $service 服务名
	 * @param $dataParam 业务参数
	 */
	function postProxy($service,array $dataParam) { 
		$config = include('config.inc.php');
		if(is_array($config)&& $config!=null){
			if(array_key_exists("cpId", $config)) 
				$config['cpId']		= intval($config['cpId']);
			if(array_key_exists("gameId", $config)) 
				$config['gameId']	= intval($config['gameId']);
			if(array_key_exists("channelId", $config)) 
				$config['channelId'] 	= intval($config['channelId']);
			if(array_key_exists("serverId", $config)) 
				$config['serverId'] 	= intval($config['serverId']);
		}else{
			Logging::logFile('debug.log',"[AccessProxy.php]".'配置为空');
			throw new exception('配置为空');
		}
		$requestString = $this->assemblyParameters($service,$dataParam,$config);
		$serverUrl= $config['serverUrl'];
		return $this->postExecute($serverUrl,$requestString);
	}
	
	/**
	 * 内部执行访问与控制的方法
	 * @param $serverUrl   访问Url
	 * @param $requestString 访问格式话后的入参
	 */
	function postExecute($serverUrl,$requestString) {
		Logging::logFile('debug.log',"[AccessProxy.php]".'访问地址:'.$serverUrl);
		//判断域名是否可用，获取内存isDomainAvailable的
		$shm = new pc_Shm();
		$cacheUrl = $shm->fetch('cacheUrl');
		$isDomainAvailable = $shm->fetch('isDomainAvailable');
		if(!empty($isDomainAvailable)&&$isDomainAvailable=='false'&&!empty($cacheUrl)){
			$serverUrl = $cacheUrl ;
			Logging::logFile('debug.log',"[AccessProxy.php]".'域名不可用');
		}
		$result = HttpClient::quickPost($serverUrl,$requestString);//http post方式调用服务器接口,请求的body内容是参数json格式字符串
		if(!$result){
			
			//$result为false，没有响应结果,说明域名或IP地址失效,启动补救机制
			//获取IP
				$ip = $this->getIP();
			//判断获取的IP否为空
			if(!empty($ip)){
				//取得IP,用新的IP列表访问
				return $this->postExecute($ip,$requestString);
			}else{
				//没有可用的访问Url
				return false;
			}
		}else{
			//检查是否为域名
			if($isDomainAvailable=='false'){
			    $shm->save('cacheUrl',$serverUrl);
			}
			
			//将响应结果返回
			return $result;
		}
	}
	
	/**
	 * 封装访问入参数据 
	 * @param unknown_type $service 服务名
	 * @param array $dataParam      业务数据
	 * @param unknown_type $config  配置文件数据
	 */
	function assemblyParameters($service,array $dataParam,$config){
		///////////////////////////////////////////////////
		$gameParam = array();
		$gameParam['cpId']			= $config['cpId'];//cpid是在游戏接入时由UC平台分配，同时分配相对应cpId的apiKey
		$gameParam['gameId']		= $config['gameId'];//gameid是在游戏接入时由UC平台分配
		$gameParam['channelId']		= $config['channelId'];//channelid是在游戏接入时由UC平台分配
		//serverid是在游戏接入时由UC平台分配，
		//若存在多个serverid情况，则根据用户选择进入的某一个游戏区而确定。
		//若在调用该接口时未能获取到具体哪一个serverid，则此时默认serverid=0
		$gameParam['serverId']		= $config['serverId'];
		////////////////////////////////////////////////
		/*
		签名规则=cpId+签名内容+apiKey
		假定cpId=109,apiKey=202cb962234w4ers2aaa,sid=abcdefg123456
		那么签名原文109sid=abcdefg123456202cb962234w4ers2aaa
		签名结果6e9c3c1e7d99293dfc0c81442f9a9984
		*/
		$signSource					= $config['cpId'].$this->getSignData($dataParam).$config['apiKey'];//组装签名原文
		$sign						= md5($signSource);//MD5加密签名
		//////////////////////////////////////////////////		
		$requestParam = array();
		$requestParam["id"] 		= time();//当前系统时间
		$requestParam["service"] 	= $service ;//"ucid.user.sidInfo";
		$requestParam['game']		= $gameParam;
		if(0==count($dataParam)){
			$requestParam['data']		= new stdClass();
		}else{
			$requestParam['data']		= $dataParam;
		}
		$requestParam['encrypt']	= "md5";
		$requestParam['sign']		= $sign;
		/////////////////////////////////////////////////
		$requestString 				= json_encode($requestParam);//把参数序列化成一个json字符串
		Logging::logFile('debug.log',"[AccessProxy.php]"."[请求参数]:".$requestString);
		Logging::logFile('debug.log',"[AccessProxy.php]"."[签名原文]:".$signSource);
		Logging::logFile('debug.log',"[AccessProxy.php]"."[签名结果]:".$sign);
		///////////////////////////////////////////////////
		return $requestString;
	}
	
	/**
	 * 按字母排序$params数组d的键,返回键+值的加密内容
	 * @param $data 业务数据
	 */
	function getSignData(array $data){
		ksort($data);
		$enData = '';
	  	foreach( $data as $key=>$val ){
			$enData = $enData.$key.'='.$val;
	  	}
	  	return $enData;
	}
	
	//传入参数为IP列表数组$ipArray.
	//$ipArray如果有IP就返回随机ip并在$ipArray将该IP剔除,没有就返回null；
	function getIP(){
//		将$ipList组装$ipArray
		if(count($this->ipArray)>1){
			$index = mt_rand(0,count($this->ipArray)-2);//这里为减2为了除去最后【,】导致数组多了最后一个值
			$ip = array_splice($this->ipArray,$index,1);
			return $ip[0];
		}else{
			return ;
		}
	}
}

?>
