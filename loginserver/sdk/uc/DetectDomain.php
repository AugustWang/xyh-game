<?php
require_once "Net/Ping.php";
include "pc_Shm.php";

class DetectDomain{
     
	//检测域名是否可用的方法 
	//【域名可用】返回true 【域名不可用】返回false;
	function detectDomainAvailable(){
		Logging::logFile('debug.log',"[DetectDomain.php]".'[开始检测域名]');
		$config = include('config.inc.php');
		$serverUrl= parse_url($config['serverUrl'], PHP_URL_HOST);
		$ping = Net_Ping::factory(); 
		//设置ping的次数为一次
		$ping->setArgs(array('count' => 1));
		$res = $ping->ping($serverUrl);
 		if(PEAR::isError($res)||$res->_received == 0||$res->_received != $res->_transmitted){
 			$shm = new pc_Shm();
			$shm->save('isDomainAvailable','false');
			Logging::logFile('debug.log',"[DetectDomain.php]".'[检测域名不可用]');
 		}else{
			$shm = new pc_Shm();
			$shm->save('isDomainAvailable','true');
			Logging::logFile('debug.log',"[DetectDomain.php]".'[域名可用]');
 		}
 		Logging::logFile('debug.log',"[DetectDomain.php]".'[结束检测域名]');
 	}
}
