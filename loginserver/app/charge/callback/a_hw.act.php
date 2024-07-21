<?php
/*-----------------------------------------------------+
 * 华为充值回调处理
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/

class Act_a_hw extends ChargeCallback{

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
        // if($this->debug) $this->log(var_export($_REQUEST, TRUE), true);
        // echo '{"result":0}';
        // return;
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
        // TEST
        // $_POST = 
        //     array (
        //         'result' => '0',
        //         'userName' => '900086000020560534',
        //         'productName' => '1元宝',
        //         'payType' => '3',
        //         'amount' => '10.00',
        //         'orderId' => '1-10003-f4719-1403337460',
        //         'notifyTime' => '1403339109367',
        //         'requestId' => '1-10003-f4719-1403337460',
        //         'sign' => 'gcOwordekN4XLzDunPlqRRgHfJRGHYjJnuw1ggDLtdKrOK9lDWAsTaODWSXuGbQSBKN+h2S0ThRT24MsQ+SsRA==',
        //     );
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
        $rsa = new MyRSA;
        $rsa->setPubKey('MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAINvoJgBnFEUZV9KDXCe9ZUsQEwpVR3tD7B8bmK9M6QTZVQdbufYoo8PdNtzXgUQUvEG0/8aB8yi/DcmRBZn35ECAwEAAQ==');
        // $rsa->setPubKey('MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAIW1g+KAqqOeC1ypte8L3qTDk2nz6jUbM6o6Jg9obvivPnCAm/wZvV3jWbYWfOuO/wrFJygn/jZqf8cR1T1CQa8CAwEAAQ=='); // TEST
        return $rsa->check($signString, $this->request['sign']);
    }
}
