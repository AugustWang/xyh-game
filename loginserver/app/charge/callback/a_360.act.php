<?php
/*-----------------------------------------------------+
 * 360充值回调处理
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/

// [2014-06-21 16:23:47] 220.181.156.196, , http://118.192.91.108/charge.php?mod=callback&act=a_360&order_id=1406215896648428711&app_key=59f1d452986e40591409a231640a90fa&product_id=1&amount=1&app_uid=a_3601013009491&user_id=1013009491&sign_type=md5&app_order_id=1-10003-j4709-1403338904&gateway_flag=success&sign=04a3352838838cb480f9b738f83a0363&sign_return=c276c471228ff7de00df77c00d4348d0
// [2014-06-21 16:23:47] 220.181.156.196, , http://charge.my/charge.php?mod=callback&act=a_360&order_id=1406215896648428711&app_key=59f1d452986e40591409a231640a90fa&product_id=1&amount=1&app_uid=a_3601013009491&user_id=1013009491&sign_type=md5&app_order_id=1-10003-j4709-1403338904&gateway_flag=success&sign=04a3352838838cb480f9b738f83a0363&sign_return=c276c471228ff7de00df77c00d4348d0
// array (
//   'mod' => 'callback',
//   'act' => 'a_360',
//   'order_id' => '1406215896648428711',
//   'app_key' => '59f1d452986e40591409a231640a90fa',
//   'product_id' => '1',
//   'amount' => '1',
//   'app_uid' => 'a_3601013009491',
//   'user_id' => '1013009491',
//   'sign_type' => 'md5',
//   'app_order_id' => '1-10003-j4709-1403338904',
//   'gateway_flag' => 'success',
//   'sign' => '04a3352838838cb480f9b738f83a0363',
//   'sign_return' => 'c276c471228ff7de00df77c00d4348d0',
// )
class Act_a_360 extends ChargeCallback{

    public function __construct(){
        parent::__construct();
    }

    public function process(){
        $this->debug = 1;
        $this->appId = "59f1d452986e40591409a231640a90fa";
        $this->appKey = "1c78501c188cd427ad828e0c3b8f0958";
        $this->platformName = $_REQUEST['act'];
        // 设置字段名
        $this->myOrderIdField = 'app_order_id';
        $this->platformOrderIdField = 'order_id';
        $this->moneyField = 'amount';
        $this->signField = 'sign';
        $this->appIdField = 'app_key';
        $this->requestFields = array(
            'app_key',
            'amount',
            'product_id',
            'app_uid',
            'order_id',
            'gateway_flag',
            'sign',
            'sign_type',
            'user_id',
            'sign_return',
            'app_ext1',
            'app_ext2',
            'app_order_id',
        );
        $this->setRequest();
        $this->appIdErrorInfo = 'AppId Error';
        $this->signErrorInfo = 'Sign Error';
        $this->failedInfo = 'error';
        // Success Info
        $this->successInfo = 'ok';
        // Go ...
        $this->run();
    }

    public function getSignString(){
        $signData = $this->request;
        unset($signData['sign']);
        unset($signData['sign_return']);
        $processedParams = array();
        foreach ($signData as $k => $v) {
            if (empty($v)) {
                continue;
            }
            $processedParams[$k] = $v;
        }
        ksort($processedParams);
        return join('#', $processedParams) . '#' . $this->appKey;
    }
}
