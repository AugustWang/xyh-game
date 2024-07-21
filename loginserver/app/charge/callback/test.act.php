<?php
/*-----------------------------------------------------+
 * TEST充值回调处理
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/

class Act_Test extends ChargeCallback{

    public function __construct(){
        parent::__construct();
    }

    public function process(){
        $this->debug = 1;
        $this->platformName = $_REQUEST['act'];
        $this->log(var_export($_REQUEST, TRUE), TRUE);
        echo "success";
    }

    public function verifySign2(){


		$MyRsa = new MyRsa;
        $data = array (
            'order_id' => '2012110900000364',
            'billno' => '8888888888888',
            'account' => 'pp123456',
            'amount' => '10',
            'status' => '0',
            'app_id' => '93',
        );
        $data1 = base64_encode(json_encode($data));
        $data2 = base64_encode(json_encode($data));
        echo 'data:'.$data2 .'<br>';

openssl_get_privatekey (MyRsa::private_key);
//openssl_private_encrypt('eyJvcmRlcl9pZCI6IjIwMTIxMTA5MDAwMDAzNjQiLCJiaWxsbm8iOiI4ODg4ODg4ODg4ODg4IiwiYWNjb3VudCI6InBwMTIzNDU2IiwiYW1vdW50IjoiMTAiLCJzdGF0dXMiOiIwIiwiYXBwX2lkIjoiOTMifQ',$finaltext,MyRsa::private_key);
openssl_private_encrypt('eyJvcmRlcl9pZCI6IjIwMTIxMTA5MDAwMDAzNjQiLCJiaWxsbm8iaaaaaaaaaaaaaaaaaaaaaaddddddddddddddddddddddddddddddddddddaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',$finaltext,MyRsa::private_key, OPENSSL_PKCS1_PADDING);
echo "String crypted:". base64_encode($finaltext);

openssl_get_publickey (MyRsa::public_key);
openssl_public_decrypt ($finaltext,$finaltext1,MyRsa::public_key, OPENSSL_PKCS1_PADDING);
echo "String decrypt : $finaltext1";

        return false;

    }

    public function verifySign(){
        $notify_data = $this->request;
        var_dump($notify_data);
		$privatedata = $notify_data['sign'];
		$privatebackdata = base64_decode($privatedata);
		$MyRsa = new MyRsa;
		$data = $MyRsa->publickey_decodeing($privatebackdata, MyRsa::public_key);
        var_dump($data);
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
			return false;
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
