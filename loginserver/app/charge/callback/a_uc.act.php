<?php
/*-----------------------------------------------------+
 * UC充值回调处理
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/
// 通知cp end,orderId:201406191726465800871,
// url:http://118.192.91.108/charge.php?mod=callback&act=a_uc,
// 参数:{"sign":"165e9b9cea7d35d79dbc4d136e73124e","data":{"failedDesc":"","amount":"10.00","callbackInfo":"1-10003-a_uc201126296-1403169943533","ucid":"201126296","gameId":"539558","payWay":"301","serverId":"3032","orderStatus":"S","orderId":"201406191726465800871"}},
// 响应:FAILURE
class Act_a_uc extends ChargeCallback{

	public $cpId = 37418;
	public $gameId = 539558;

    public function __construct(){
        parent::__construct();
    }

    public function setRequest(){
        // TEST
        //通知cp end,orderId:201406191752565800875,url:http://118.192.91.108/charge.php?mod=callback&act=a_uc,参数:{"sign":"bf0cfd5d880619d05ee400423ecb2067","data":{"failedDesc":"","amount":"10.00","callbackInfo":"1-10003-a_uc201126296-1403171530901","ucid":"201126296","gameId":"539558","payWay":"301","serverId":"3032","orderStatus":"S","orderId":"201406191752565800875"}},响应:FAILURE
        $request = file_get_contents("php://input");
        // $request = '{"sign":"bf0cfd5d880619d05ee400423ecb2067","data":{"failedDesc":"","amount":"10.00","callbackInfo":"1-10003-a_uc201126296-1403171530901","ucid":"201126296","gameId":"539558","payWay":"301","serverId":"3032","orderStatus":"S","orderId":"201406191752565800875"}}';
        if($this->debug) $this->log('request:'.$request);
        $responseData = json_decode($request,true);
        $this->request = $responseData['data'];
        $this->request['sign'] = $responseData['sign'];
    }

    public function process(){

        $this->debug = 1;
        $this->appId = '539558';
        $this->appKey = "5aec7f588b3033f17d0c49c8cc37179c";
        $this->platformName = 'a_uc';
        // 设置字段名
        $this->myOrderIdField = 'callbackInfo';
        $this->platformOrderIdField = 'orderId';
        $this->moneyField = 'amount';
        $this->moneyUnit = 100;
        $this->signField = 'sign';
        $this->appIdField = 'gameId';
        $this->setRequest();
        $signData = $this->request;
        unset($signData['sign']);
        ksort($signData);
        $this->signData = $signData;
        $this->signSep2 = '';
        // 验证订单状态
        if($this->request['orderStatus'] != 'S'){
            $this->log('error orderStatus:'.$this->request['orderStatus']);
            echo 'FAILURE';
            return;
        }
        // Error Info
        $this->appIdErrorInfo = 'FAILURE';
        $this->signErrorInfo = 'FAILURE';
        $this->failedInfo = 'FAILURE';
        // Success Info
        $this->successInfo = 'SUCCESS';
        // Go ...
        $this->run();
    }

    public function getSignString(){
        $sign_array = array();
        foreach ($this->signData as $k => $v) {
            $sign_array[] = $k . $this->signSep1 . $v;
        }
        return $this->cpId.join($this->signSep2, $sign_array).$this->appKey;
    }

}
