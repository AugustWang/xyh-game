<?php
/*-----------------------------------------------------+
 * PP充值回调处理
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/
// order_id bigint(20) 兑换订单号是
// billno varchar(50) 厂商订单号（原样返回给游戏服） 是
// account varchar(50) 通行证账号是
// amount double(8,2) 兑换PP 币数量是
// status tinyint(1) 状态: 0 正常状态 1 已兑换过并成功返回 是
// app_id int(10) 厂商应用ID（原样返回给游戏服） 是
// uuid char(40) 设备号（返回的uuid 为空） 是
// roleid varchar(50) 厂商应用角色id（原样返回给游戏服） 是
// zone int(10) 厂商应用分区id（原样返回给游戏服） 是
// sign text 签名(RSA 私钥加密) 是
//
class Act_i_pp extends ChargeCallback{

    public function __construct(){
        parent::__construct();
    }

    public function process(){
        $this->debug = 1;
        $this->appId = 3603;
        $this->appKey = "2da6c32610f7c768d99bc2e9ec374720";
        $this->platformName = $_REQUEST['act'];
        // 设置字段名
        $this->myOrderIdField = 'billno';
        $this->platformOrderIdField = 'order_id';
        $this->moneyField = 'amount';
        $this->moneyUnit = 10;
        $this->signField = 'sign';
        $this->appIdField = 'app_id';
        $this->requestFields = array(
            'order_id',
            'billno',
            'account',
            'amount',
            'status',
            'app_id',
            'uuid',
            'role_id',
            'zone',
            'sign',
        );

        if($this->debug) $this->log(var_export($_REQUEST, TRUE));
        $this->setRequest();
        // 验证AppId
        // if(!$this->verifyAppId()){
        //     echo 'fail';
        //     return;
        // }
        // 验证签名
        if(!$this->verifySign()){
            echo 'fail';
            return;
        }
        // Save
        $this->saveOrder();
        // OK
        echo "success";
    }

    public function verifySign(){
        $notify_data = $this->request;
		$privatedata = $notify_data['sign'];
		$privatebackdata = base64_decode($privatedata);
		$MyRsa = new MyRsa;
		$data = $MyRsa->publickey_decodeing($privatebackdata, MyRsa::public_key);
		/*
		$ex_data = explode("&",$data);
		$rs = array();
		foreach($ex_data as $v){
			$k_v = explode("=",$v);
			$rs[$k_v[0]] = $k_v[1];
		}
		*/
		$rs = json_decode($data,true);
		if(empty($rs)||empty($notify_data))return false;
		if($rs["billno"] == $notify_data['billno']&&$rs["amount"] == $notify_data['amount']&&$rs["status"] == $notify_data['status']) {
			return true; 
		}else{
            $this->log(var_export($rs, TRUE));
			return true;
		}
    }

}

/**
 * rsa
 * 需要 openssl 支持
 * @author andsky
 *
 */
class MyRsa extends Rsa
{

    private static $_instance;

    const private_key = '
-----BEGIN RSA PRIVATE KEY-----
MIICXAIBAAKBgQDA4E8H2qksOnCSoBkq+HH3Dcu0/iWt3iNcpC/BCg0F8tnMhF1Q
OQ98cRUM8eeI9h+S6g/5UmO4hBKMOP3vg/u7kI0ujrCN1RXpsrTbWaqry/xTDgTM
8HkKkNhRSyDJWJVye0mPgbvVnx76en+K6LLzDaQH8yKI/dbswSq65XFcIwIDAQAB
AoGAU+uFF3LBdtf6kSGNsc+lrovXHWoTNOJZWn6ptIFOB0+SClVxUG1zWn7NXPOH
/WSxejfTOXTqpKb6dv55JpSzmzf8fZphVE9Dfr8pU68x8z5ft4yv314qLXFDkNgl
MeQht4n6mo1426dyoOcCfmWc5r7LQCi7WmOsKvATe3nzk/kCQQDp1gyDIVAbUvwe
tpsxZpAd3jLD49OVHUIy2eYGzZZLK3rA1uNWWZGsjrJQvfGf+mW+/zeUMYPBpk0B
XYqlgHJNAkEA0yhhu/2SPJYxIS9umCry1mj7rwji5O2qVSssChFyOctcbysbNJLH
qoF7wumr9PAjjWFWdmCzzEJyxMMurL3gLwJBAIEoeNrJQL0G9jlktY3wz7Ofsrye
j5Syh4kc8EBbuCMnDfOL/iAI8zyzyOxuLhMmNKLtx140h0kkOS6C430M2JUCQCnM
a5RX/JOrs2v7RKwwjENvIqsiWi+w8C/NzPjtPSw9mj2TTd5ZU9bnrMUHlnd09cSt
yPzD5bOAT9GtRVcCexcCQBxXHRleikPTJC90GqrC2l6erYJaiSOtv6QYIh0SEDVm
1o6Whw4FEHUPqMW0Z5PobPFiEQT+fFR02xU3NJrjYy0=
-----END RSA PRIVATE KEY-----';
    const public_key = '
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDA4E8H2qksOnCSoBkq+HH3Dcu0
/iWt3iNcpC/BCg0F8tnMhF1QOQ98cRUM8eeI9h+S6g/5UmO4hBKMOP3vg/u7kI0u
jrCN1RXpsrTbWaqry/xTDgTM8HkKkNhRSyDJWJVye0mPgbvVnx76en+K6LLzDaQH
8yKI/dbswSq65XFcIwIDAQAB
-----END PUBLIC KEY-----';
    
    
    function __construct ()
    {
    }


    function __destruct ()
    {
    }

    public static function instance()
    {
        if (self::$_instance == null) {
            self::$_instance = new self;
        }
        return self::$_instance;
    }


    function sign($sourcestr = NULL)
    {

        return base64_encode(parent::sign($sourcestr, self::private_key));

    }

    function verify($sourcestr = NULL, $signature = NULL)
    {
        return parent::verify($sourcestr, $signature, self::public_key);

    }


}
