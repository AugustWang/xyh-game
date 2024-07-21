<?php
/*-----------------------------------------------------+
 * OPPO充值回调处理
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/
// 游戏名称：萌兽堂
// 游戏ID：1679
// 游戏key：E30760pgTy8Kg4w04kWww8ww0
// 游戏secret：f42a9b6406Ba507495176c88073E582c
//
// 参数名 说明 类型及长度限制
// notifyId 回调通知ID（该值使用系统为这次支付生 成的订单号） String(50)
// partnerOrder 开发者订单号（客户端上传） String(100)
// productName 商品名称（客户端上传） String(50)
// productDesc 商品描述（客户端上传） String(100)
// price 商品价格(以分为单位) int
// count 商品数量（一般为1） int
// attach 请求支付时上传的附加参数（客户端上传） String(200)
// sign 签名 String
class Act_Android_oppo extends ChargeCallback{

    public function __construct(){
        parent::__construct();
    }

    public function process(){
        $this->debug = 1;
        $this->appId = "1679";
        $this->appKey = "E30760pgTy8Kg4w04kWww8ww0";
        $this->platformName = $_REQUEST['act'];
        // 设置字段名
        $this->myOrderIdField = 'partnerOrder';
        $this->platformOrderIdField = 'notifyId';
        $this->moneyField = 'price';
        $this->signField = 'sign';
        $this->appIdField = '';
        $this->requestFields = array(
            'notifyId',
            'partnerOrder',
            'productName',
            'productDesc',
            'price',
            'count',
            'attach',
            'sign',
        );

        if($this->debug) $this->log(var_export($_REQUEST, TRUE));
        $this->setRequest();
        // 验证签名
        if(!rsa_verify($_POST)){
            die('result=FAIL&resultMsg=验证错误');
        } 
        // Save
        $this->saveOrder();
        // OK
        echo 'ok';
    }

    public function rsa_verify($contents) {
        $str_contents = "notifyId={$contents['notifyId']}&partnerOrder={$contents['partnerOrder']}&productName={$contents['productName']}&productDesc={$contents['productDesc']}&price={$contents['price']}&count={$contents['count']}&attach={$contents['attach']}";
        $publickey= 'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCmreYIkPwVovKR8rLHWlFVw7YDfm9uQOJKL89Smt6ypXGVdrAKKl0wNYc3/jecAoPi2ylChfa2iRu5gunJyNmpWZzlCNRIau55fxGW0XEu553IiprOZcaw5OuYGlf60ga8QT6qToP0/dpiL/ZbmNUO9kUhosIjEu22uFgR+5cYyQIDAQAB';
        $pem = chunk_split($publickey,64,"\n");
        $pem = "-----BEGIN PUBLIC KEY-----\n".$pem."-----END PUBLIC KEY-----\n";
        $public_key_id = openssl_pkey_get_public($pem);
        $signature =base64_decode($contents['sign']);
        return openssl_verify($str_contents, $signature, $public_key_id );
}

}
