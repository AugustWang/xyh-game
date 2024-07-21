<?php
/*-----------------------------------------------------+
 * 91充值回调处理
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/

class Act_a_91 extends ChargeCallback{

    public function __construct(){
        parent::__construct();
    }

    public function process(){
        $this->debug = 1;
        $this->appId = '113852';
        $this->appKey = "543347cade281022624542c2a9c5781a9e16a523e216d802";
        $this->platformName = 'a_91';
        // 设置字段名
        $this->myOrderIdField = 'CooOrderSerial';
        $this->platformOrderIdField = 'ConsumeStreamId';
        $this->moneyField = 'OrderMoney';
        $this->moneyUnit = 100;
        $this->signField = 'Sign';
        $this->appIdField = 'AppId';
        $this->requestFields = array(
            'AppId',          
            'Act',            
            'ProductName',    
            'ConsumeStreamId',
            'CooOrderSerial', 
            'Uin',            
            'GoodsId',        
            'GoodsInfo',      
            'GoodsCount',     
            'OriginalMoney',  
            'OrderMoney',     
            'Note',           
            'PayStatus',      
            'CreateTime',     
            'Sign',           
        );

        $this->setRequest();

        //因为这个DEMO是接收验证支付购买结果的操作，所以如果此值不为1时就是无效操作
        if($_REQUEST['Act'] != 1){
            $this->log('Act Error:' . var_export($data, TRUE));
            echo '{"ErrorCode":"3","ErrorDesc":"Act无效"}';
            return;

        }

        // Error Info
        $this->appIdErrorInfo = '{"ErrorCode":"2","ErrorDesc":"AppId无效"}';
        $this->signErrorInfo = '{"ErrorCode":"5","ErrorDesc":"Sign无效"}';
        $this->failedInfo = '{"ErrorCode":"0","ErrorDesc":"失败"}';
        // Success Info
        $this->successInfo = '{"ErrorCode":"1","ErrorDesc":"接收成功"}';
        if(!$this->debug && $this->request['debug']){
            // NO DEBUG
            echo $this->failedInfo;
            return;
        }
        // Go ...
        $this->run();
    }

    public function getSignString(){
        $AppId 				= $_REQUEST['AppId'];//应用ID
        $Act	 			= $_REQUEST['Act'];//操作
        $ProductName		= $_REQUEST['ProductName'];//应用名称
        $ConsumeStreamId	= $_REQUEST['ConsumeStreamId'];//消费流水号
        $CooOrderSerial	 	= $_REQUEST['CooOrderSerial'];//商户订单号
        $Uin			 	= $_REQUEST['Uin'];//91帐号ID
        $GoodsId		 	= $_REQUEST['GoodsId'];//商品ID
        $GoodsInfo		 	= $_REQUEST['GoodsInfo'];//商品名称
        $GoodsCount		 	= $_REQUEST['GoodsCount'];//商品数量
        $OriginalMoney	 	= $_REQUEST['OriginalMoney'];//原始总价（格式：0.00）
        $OrderMoney		 	= $_REQUEST['OrderMoney'];//实际总价（格式：0.00）
        $Note			 	= $_REQUEST['Note'];//支付描述
        $PayStatus		 	= $_REQUEST['PayStatus'];//支付状态：0=失败，1=成功
        $CreateTime		 	= $_REQUEST['CreateTime'];//创建时间
        $Sign		 		= $_REQUEST['Sign'];//91服务器直接传过来的sign
        return $this->appId.$Act.$ProductName.$ConsumeStreamId.$CooOrderSerial.$Uin.$GoodsId.$GoodsInfo.$GoodsCount.$OriginalMoney.$OrderMoney.$Note.$PayStatus.$CreateTime.$this->appKey;
    }
}
