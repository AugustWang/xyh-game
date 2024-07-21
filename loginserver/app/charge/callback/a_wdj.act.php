<?php
/*-----------------------------------------------------+
 * 豌豆荚充值回调处理
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/

// array (
//   'sign' => 'KtGDXYoyKhRmKDDd8lA1AASD6FxlrrOjWlZDzvSA4fXAIfIosTMJYG+21H7txQP+ISGfvYLSmdTCjeFnV6DVDGZKS6852484Tqc90xT1p6qnAof/Y8xFv0D/rB6ELh4YoopsWmWozrgo4h7CKiOJuPd+a24Ph2FuumWMjSv+/c0=',
//   'content' => '{"orderId":121916021,"appKeyId":100001623,"buyerId":75631523,"cardNo":null,"money":1,"chargeType":"ALIPAY","timeStamp":1401498575234,"out_trade_no":"4512cb3e-cdd7-fad3-2916-4fd26f9b9526"}',
//   'signType' => 'RSA',
// )


class Act_a_wdj extends ChargeCallback{

    public $jsonContent;

    public function __construct(){
        parent::__construct();
    }

    public function process(){

        // TEST DATA
        // $_REQUEST = array (
        //     'sign' => 'KtGDXYoyKhRmKDDd8lA1AASD6FxlrrOjWlZDzvSA4fXAIfIosTMJYG+21H7txQP+ISGfvYLSmdTCjeFnV6DVDGZKS6852484Tqc90xT1p6qnAof/Y8xFv0D/rB6ELh4YoopsWmWozrgo4h7CKiOJuPd+a24Ph2FuumWMjSv+/c0=',
        //     'content' => '{"orderId":121916021,"appKeyId":100001623,"buyerId":75631523,"cardNo":null,"money":1,"chargeType":"ALIPAY","timeStamp":1401498575234,"out_trade_no":"4512cb3e-cdd7-fad3-2916-4fd26f9b9526"}',
        //     'signType' => 'RSA',
        // );

        $this->debug = 1;
        $this->appId = '100001623';
        $this->appKey = "98afbc1da57c0a19a9520971744239aa";
        $this->platformName = 'a_wdj';

        // 设置字段名
        $this->myOrderIdField = 'out_trade_no';
        $this->platformOrderIdField = 'orderId';
        $this->moneyField = 'money';
        $this->moneyUnit = 1;
        $this->signField = 'sign';
        $this->appIdField = 'appKeyId';
        $this->jsonContent = stripslashes($_REQUEST['content']);
        $this->setRequest();
        // Error Info
        $this->appIdErrorInfo = 'fail';
        $this->signErrorInfo = 'fail';
        $this->failedInfo = 'fail';
        // Success Info
        $this->successInfo = 'success';
        // Go ...
        $this->run();
    }

    public function verifySign(){
        $rsa = new MyRSA;
        $rsa->setPubKey('MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCd95FnJFhPinpNiE/h4VA6bU1rzRa5+a25BxsnFX8TzquWxqDCoe4xG6QKXMXuKvV57tTRpzRo2jeto40eHKClzEgjx9lTYVb2RFHHFWio/YGTfnqIPTVpi7d7uHY+0FZ0lYL5LlW4E2+CQMxFOPRwfqGzMjs1SDlH7lVrLEVy6QIDAQAB');
        return $rsa->check($this->jsonContent, $_REQUEST['sign']);
    }

    public function setRequest(){
        $params = array();
        $params = json_decode($this->jsonContent, true);
        $params['sign'] = $_REQUEST['sign'];
        $this->request = $params;
    }
}

