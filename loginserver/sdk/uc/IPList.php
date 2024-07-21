<?php
include "pc_Shm.php";
include "AccessProxy.php";
/**
 *获取IP列表的类
 */
class IPList{
	/**
	 * 组装ip和port的方法
	 * @param unknown_type $ip
	 * @param unknown_type $port
	 */	
	function getServerUrl($ip,$port){
		$ipUrl='';
		$config = include('config.inc.php');
		$url = parse_url($config['serverUrl']);
		$scheme = strtolower($url['scheme']) ; //取域名部分
		$path = strtolower($url['path']) ; //取域名部分
		if(!empty($port)){
			$ipUrl = $scheme."://".$ip.":".$port.$path;
		}else{
			$ipUrl = $scheme."://".$ip.$path;
		}
		return $ipUrl;
	}
	
	/**
	 * 获取IP列表的方法
	 */
	public function getIPListMethod(){
		Logging::logFile('debug.log',"[IPList.php]".'[开始调用getIPList接口]');
		///////////////////////////////////////////////////
		$dataParam = array();
		$service="system.getIPList"; 
		$ap = new AccessProxy();
		$result = $ap->postProxy($service,$dataParam);//http post方式调用服务器接口,请求的body内容是参数json格式字符串
		///////////////////////////////////////////////////
		Logging::logFile('debug.log',"[IPList.php]"."[调用getIPList接口结束]");	
		Logging::logFile('debug.log',"[IPList.php]".'[响应结果]'.$result);
		$responseData = json_decode($result,true);//结果也是一个json格式字符串
		if($responseData!=null){//反序列化成功，输出其对象内容
			Logging::logFile('debug.log',"[IPList.php]"."[id]:".$responseData['id']);
			Logging::logFile('debug.log',"[IPList.php]"."[code]:".$responseData['state']['code']);
			Logging::logFile('debug.log',"[IPList.php]"."[msg]:".$responseData['state']['msg']);
			$data = $responseData['data'];
			if(!empty($data)&&!empty($data['list'])){
				$ipList = "";
				foreach ($data['list'] as $ip){
					if(!empty($ip)&&!empty($ip['ip'])){
						Logging::logFile('debug.log',"[IPList.php]"."[ip]:".$ip['ip']);
						Logging::logFile('debug.log',"[IPList.php]"."[port]:".$ip['port']);
						Logging::logFile('debug.log',"[IPList.php]"."[isp]:".$ip['isp']);
						$ipList = $ipList.$this->getServerUrl($ip['ip'],$ip['port']).",";
					}
				}
				if(!empty($ipList)){
					//保存写入内存
					$shm = new pc_Shm();
		            //$shm->setSize(20000);
					$shm->save('ipList',$ipList);
				}else{
					Logging::logFile('debug.log',"[IPList.php]"."返回IP列表数据异常或为空");
					throw new Exception("返回IP列表数据异常或为空");
				}
			}else{
				Logging::logFile('debug.log',"[IPList.php]"."返回IP列表为空");
				throw new Exception("返回IP列表为空");
			}
		}else{
			Logging::logFile('debug.log',"[IPList.php]"."[获取IP列表的接口返回异常]");
			throw new Exception("[获取IP列表的接口返回异常]");
		}
	}
}

