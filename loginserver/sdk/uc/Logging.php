<?php
class Logging {
	function logFile($filename,$msg){
		
		//打开文件
		$fd = fopen($filename,"a");
		date_default_timezone_set('Asia/Shanghai');
		//增加文件
		$str = "[".date("Y/m/d H:i:s",time())."]".$msg;
		//写入字符串
		fwrite($fd, $str."\n");
		//关闭文件
		fclose($fd);
	}
}
?>
