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


class Act_Android_wdj extends ChargeCallback{

    public $jsonContent;

    public function __construct(){
        parent::__construct();
    }

    public function process(){

        $this->debug = 1;
        $this->appId = '100001623';
        $this->appKey = "98afbc1da57c0a19a9520971744239aa";
        $this->platformName = 'a_wdj';

        // TEST DATA
        // $_REQUEST = array (
        //     'sign' => 'KtGDXYoyKhRmKDDd8lA1AASD6FxlrrOjWlZDzvSA4fXAIfIosTMJYG+21H7txQP+ISGfvYLSmdTCjeFnV6DVDGZKS6852484Tqc90xT1p6qnAof/Y8xFv0D/rB6ELh4YoopsWmWozrgo4h7CKiOJuPd+a24Ph2FuumWMjSv+/c0=',
        //     'content' => '{"orderId":121916021,"appKeyId":100001623,"buyerId":75631523,"cardNo":null,"money":1,"chargeType":"ALIPAY","timeStamp":1401498575234,"out_trade_no":"4512cb3e-cdd7-fad3-2916-4fd26f9b9526"}',
        //     'signType' => 'RSA',
        // );


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
        $rsa=new Rsa;
        return $rsa->verify($this->jsonContent, $_REQUEST['sign']);
    }

    public function setRequest(){
        $params = array();
        $params = json_decode($this->jsonContent, true);
        $params['sign'] = $_REQUEST['sign'];
        $this->request = $params;
    }
}

/**
 * * 使用 openssl 实现非对称加密
 */
class Rsa {


    const PUBKEY = 'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCd95FnJFhPinpNiE/h4VA6bU1rzRa5+a25BxsnFX8TzquWxqDCoe4xG6QKXMXuKvV57tTRpzRo2jeto40eHKClzEgjx9lTYVb2RFHHFWio/YGTfnqIPTVpi7d7uHY+0FZ0lYL5LlW4E2+CQMxFOPRwfqGzMjs1SDlH7lVrLEVy6QIDAQAB';
    const PRIKEY = '';
    private $_privKey;
    /**
     * * private key
     */
    private $_pubKey;
    /**
     * * public key
     */
    private $_keyPath;
    /**
     * * the keys saving path
     */
    /**
     * * the construtor,the param $path is the keys saving path
     */
    public function __construct() {

    }

    /**
     * * setup the private key
     */
    private function setupPrivKey() {
        if (is_resource ( $this->_privKey )) {
            return true;
        }

        $pem = chunk_split(self::PRIKEY,64,"\n");
        $pem = "-----BEGIN PRIVATE KEY-----\n".$pem."-----END PRIVATE KEY-----\n";

        $this->_privKey = openssl_pkey_get_private ( $pem );
        return true;
    }

    /**
     * * setup the public key
     */
    private function setupPubKey() {
        if (is_resource ( $this->_pubKey )) {
            return true;
        }

        $pem = chunk_split(self::PUBKEY,64,"\n");
        $pem = "-----BEGIN PUBLIC KEY-----\n".$pem."-----END PUBLIC KEY-----\n";
        $this->_pubKey = openssl_pkey_get_public ( $pem );
        return true;
    }

    /**
     * * encrypt with the private key
     */
    public function privEncrypt($data) {
        if (! is_string ( $data )) {
            return null;
        }
        $this->setupPrivKey ();
        $r = openssl_private_encrypt ( $data, $encrypted, $this->_privKey );
        if ($r) {
            return base64_encode ( $encrypted );
        }
        return null;
    }

    /**
     * * decrypt with the private key
     */
    public function privDecrypt($encrypted) {
        if (! is_string ( $encrypted )) {
            return null;
        }
        $this->setupPrivKey ();
        $encrypted = base64_decode ( $encrypted );
        $r = openssl_private_decrypt ( $encrypted, $decrypted, $this->_privKey );
        if ($r) {
            return $decrypted;
        }
        return null;
    }

    /**
     * * encrypt with public key
     */
    public function pubEncrypt($data) {
        if (! is_string ( $data )) {
            return null;
        }
        $this->setupPubKey ();
        $r = openssl_public_encrypt ( $data, $encrypted, $this->_pubKey );
        if ($r) {
            return base64_encode ( $encrypted );
        }
        return null;
    }

    /**
     * * decrypt with the public key
     */
    public function pubDecrypt($crypted) {
        if (! is_string ( $crypted )) {
            return null;
        }
        $this->setupPubKey ();
        $crypted = base64_decode ( $crypted );
        $r = openssl_public_decrypt ( $crypted, $decrypted, $this->_pubKey );
        if ($r) {
            return $decrypted;
        }
        return null;
    }


    /**
     * 签名
     * @param 被签名数据 $dataString
     * @return string
     */
    public function sign($dataString){
        $this->setupPrivKey();
        $signature = false;
        openssl_sign($dataString, $signature, $this->_privKey);
        return base64_encode($signature);
    }

    /**
     * 验证签名
     * @param 被签名数据 $dataString
     * @param 已经签名的字符串 $signString
     * @return number
     */
    public function verify($dataString,$signString) {
        $this->setupPubKey();
        $signature =base64_decode($signString);
        $flg = openssl_verify($dataString, $signature, $this->_pubKey );
        return $flg;
    }

    public function check($dataString,$signString) {
        if($this->verify($dataString,$signString)==1)
            return true;
        return false;
    }

    public function __destruct() {
        @ openssl_free_key ( $this->_privKey );
        @ openssl_free_key ( $this->_pubKey );
    }
}

