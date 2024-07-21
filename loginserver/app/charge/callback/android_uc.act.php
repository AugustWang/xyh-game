<?php
/*-----------------------------------------------------+
 * UC充值回调处理
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/

class Act_Android_uc extends ChargeCallback{

	public $cpId = 37418;
	public $gameId = 539558;

    public function __construct(){
        parent::__construct();
    }

    public function process(){
        // TEST
        $_REQUEST['sign'] = "da6ed944d151cedef36ea150a91488c1";
        $_REQUEST['data'] = '{"failedDesc":"","amount":"30.0","callbackInfo":"serverip=sgall#channel=502#user=288287224.uc","ucid":"10000","gameId":"1","payWay":"1","serverId":"1132","orderStatus":"S","orderId":"20120312113248863160"}';

        $this->debug = 1;
        $this->appId = '539558';
        $this->appKey = "5aec7f588b3033f17d0c49c8cc37179c";
        $this->platformName = 'android_uc';
        // 设置字段名
        $this->myOrderIdField = 'callbackInfo';
        $this->platformOrderIdField = 'orderId';
        $this->moneyField = 'amount';
        $this->moneyUnit = 100;
        $this->signField = 'sign';
        $this->appIdField = 'gameId';

        if($this->debug) $this->log(var_export($_REQUEST, TRUE));
        $this->setRequest2('data', 'sign');
        // 验证订单状态
        if($this->request['orderStatus'] != 'S'){
            echo 'FAILURE';
            return;
        }
        // 验证AppId
        if(!$this->verifyAppId()){
            echo 'Error GameId';
            return;
        }
        // 验证签名
        if(!$this->verifySign()){
            echo 'FAILURE';
            return;
        }
        // Save
        $this->saveOrder();
        // OK
        echo 'SUCCESS';
    }

    public function getSignString(){
        return $this->cpId."amout=".$this->request['amount']."callbackInfo=".$this->request['callbackInfo']."failedDesc=".$this->request['failedDesc']."gameId=".$this->request['gameId']."orderId=".$this->request['orderId']."orderStatus=".$this->request['orderStatus']."payWay=".$this->request['payWay']."serverId=".$this->request['serverId']."ucid=".$this->request['ucid'].$this->appKey;
    }

}
