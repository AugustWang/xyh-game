<?php
/*-----------------------------------------------------+
 * 360充值回调处理
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/

class Act_Android_360 extends ChargeCallback{

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
        return join('#', $processedParams) . '#' . $appSecret;
    }
}
