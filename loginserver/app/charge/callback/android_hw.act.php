<?php
/*-----------------------------------------------------+
 * KP充值回调处理
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/

class Act_Android_hw extends ChargeCallback{

    public function __construct(){
        parent::__construct();
    }

    public function process(){
        // Debug
        $this->debug = 1;
        // App ID
        $this->appId = '10155580';
        // $this->appIdField = 'appid';
        // App Key
        $this->appKey = 'gtkxyh7sonx5ddkkf6btgln03ver4eyt';
        // PlatformName
        $this->platformName = $_REQUEST['act'];
        // 设置字段名
        $this->myOrderIdField = 'requestId';
        $this->platformOrderIdField = 'orderId';
        $this->moneyField = 'amount';
        $this->moneyUnit = 100;
        $this->signField = 'sign';
        // 操作结果，0 表示成功，
        // 1: 验签失败,
        // 2: 超时,
        // 3: 业务信息错误，比如订单不存在,
        // 94: 系统错误,
        // 95: IO 错误,
        // 96: 错误的url,
        // 97: 错误的响应,
        // 98: 参数错误,
        // 99: 其他错误
        //{"result":0} 
        // Error Info
        $this->appIdErrorInfo = '{"result":98}';
        $this->signErrorInfo = '{"result":1}';
        $this->failedInfo = '{"result":99}';
        // Success Info
        $this->successInfo = '{"result":0}';
        // setRequest
        $this->setRequest();
        // Go ...
        $this->run();
    }

    public function setRequest(){
        ksort($_POST);
        $this->request = $_POST;
    }

    public function verifySign(){
        $signString = "";
        $i = 0;
        foreach($this->request as $key=>$value)
        {
            if($key != "sign" )
            {
                $signString .= ($i == 0 ? '' : '&').$key.'='.$value;
            }
            $i++;
        }
        $pubKey = '-----BEGIN PUBLIC KEY-----
MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAKK9kzY3oGoRM3YZE04tYPXspSQDbfUd
uAN3E89v+Gu4ZuqUqOEstb4p7a01kEj8KwtyFUywH7cncygphQXcnRsCAwEAAQ==
-----END PUBLIC KEY-----';
        $openssl_public_key = @openssl_get_publickey($pubKey);
        $result = @openssl_verify($signString, base64_decode($sign), $openssl_public_key);
        @openssl_free_key($openssl_public_key);
        return $result;
    }
}
