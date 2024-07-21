<?php
/*-----------------------------------------------------+
 * KP充值回调处理
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/

// exorderno	外部订单号	String	Max(50) 
// transid	交易流水号	String	Max(32) 
// appid	游戏id	String	Max(20) 
// waresid	商品编码	integer	Max(8) 
// feetype	计费方式	integer	Max(3) 
// money	交易金额	integer	Max(10) 
// count		购买数量	integer	Max(10) 
// result	交易结果	integer	Max(2) 
// transtype	交易类型	integer	Max(2) 
// transtime	交易时间	String	Max(20) 
// cpprivate	商户私有信息	String	Max(128)
// paytype	支付方式	integer	Max(2)

class Act_Android_kp extends ChargeCallback{

    public function __construct(){
        parent::__construct();
    }

    public function process(){
        $_REQUEST['transdata'] = '{"exorderno":"1-10001-android_kp34196204-1401954132","transid":"02113013118562300203","waresid":1,"appid":"20004600000001200046","feetype":0,"money":3000,"count":1,"result":0,"transtype":0,"transtime":"2013-01-31 18:57:27","cpprivate":"123456"}';
        $_REQUEST['sign'] = '28adee792782d2f723e17ee1ef877e7 166bc3119507f43b06977786376c0434 633cabdb9ee80044bc8108d2e9b3c86e';
        // Debug
        $this->debug = 1;
        // App ID
        $this->appId = "3000464951";
        // $this->appIdField = 'appid';
        // App Key
        $this->appKey = 'MjhERTEwQkFBRDJBRTRERDhDM0FBNkZBMzNFQ0RFMTFCQTBCQzE3QU1UUTRPRFV6TkRjeU16UTVNRFUyTnpnek9ETXJNVE15T1RRME9EZzROVGsyTVRreU1ETXdNRE0zTnpjd01EazNNekV5T1RJek1qUXlNemN4'; // TEST
        // $this->appKey = "NjA2QTU4MjZCRjMwMDU4NDUwQjc0MTAzQ0NCREQ0RDkyQjY5MTUyQk1UVXpPRGt3TURZMU5qZzVPRGt4TVRVeU9Ea3JPVFkyTWpZME1EYzBOREl3TkRZMU1qVTNNVEF4T1RVd01UQTBOVEl4TURjNE9USTJORGM9";
        // PlatformName
        $this->platformName = $_REQUEST['act'];
        // 设置字段名
        $this->myOrderIdField = 'exorderno';
        $this->platformOrderIdField = 'transid';
        $this->moneyField = 'money';
        $this->signField = 'sign';
        // Error Info
        $this->appIdErrorInfo = 'FAILED';
        $this->signErrorInfo = 'FAILED';
        $this->failedInfo = 'FAILED';
        // Success Info
        $this->successInfo = 'SUCCESS';
        // setRequest
        $this->setRequest2('transdata', 'sign');
        // Go ...
        $this->run();
    }

    public function verifySign(){
        $trans_data = $_REQUEST['transdata'];
        $sign = $_REQUEST['sign'];
        $key = $this->appKey;
		$key1 =  base64_decode($key);
		$key2 = substr($key1,40,strlen($key1)-40);
		$key3 = base64_decode($key2);
		//php 5.3环境用下面这个
		list($private_key, $mod_key) = explode("+", $key3);
		//list($private_key, $mod_key) = split("\\+", $key3);
		//使用解析出来的key，解密包体中传过来的sign签名值
		$sign_md5 = $this->decrypt($sign, $private_key, $mod_key);
		$msg_md5 = md5($trans_data);
		// echo "key3 : {$key3} <br/>\n";
		// echo "private_key : {$private_key} <br/>\n";
		// echo "mod_key : {$mod_key} <br/>\n";
		// echo "sign_md5 : {$sign_md5} <br/>\n";
		// echo "msg_md5 : {$msg_md5} <br/>\n";
		return (strcmp($msg_md5,$sign_md5) == 0);
    }

	/**
	 * 解密方法
	 * @param $string 需要解密的密文字符
	 * @param $d
	 * @param $n
	 * @return String
	 */
	public function decrypt($string, $d, $n){
		//解决某些机器验签时好时坏的bug
		//BCMath 里面的函数 有的机器php.ini设置不起作用
		//要在RSAUtil的方法decrypt 加bcscale(0);这样一行代码才行
		//要不有的机器计算的时候会有小数点 就会失败
		bcscale(0);
		$bln = 64 * 2 - 1;
		$bitlen = ceil($bln / 8);
		$arr = explode(' ', $string);
		$data = '';
		foreach($arr as $v){
			$v = self::hex2dec($v);
			$v = bcpowmod($v, $d, $n);
			$data .= self::int2byte($v);
		}
		return trim($data);
	}

	public static function hex2dec($num){
		$char = '0123456789abcdef';
		$num = strtolower($num);
		$len = strlen($num);
		$sum = '0';
		for($i = $len - 1, $k = 0; $i >= 0; $i--, $k++){
			$index = strpos($char, $num[$i]);
			$sum = bcadd($sum, bcmul($index, bcpow('16', $k)));
		}
		return $sum;
	}

	public static function int2byte($num){
		$arr = array();
		$bit = '';
		while(bccomp($num, '0') > 0){
			$asc = bcmod($num, '256');
			$bit = chr($asc) . $bit;
			$num = bcdiv($num, '256');
		}
		return $bit;
	}
}
