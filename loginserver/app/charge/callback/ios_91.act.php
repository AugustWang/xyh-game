<?php
/*-----------------------------------------------------+
 * 91充值回调处理
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/
// 应用Id： 114312
// APPKEY： 64f868fc07fb3c688243f176061f982a32035b99ed0a86ce
// 应用平台： iOS
class Act_ios_91 extends ChargeCallback{

    public function __construct(){
        parent::__construct();
    }

    public function process(){
        # $_REQUEST = array (
        #     'mod' => 'callback',
        #     'act' => '91_ios',
        #     'AppId' => '114312',
        #     'ProductId' => '114312',
        #     'Act' => '1',
        #     'ProductName' => '萌兽堂',
        #     'ConsumeStreamId' => '2-34433-20140604115858-1000-8780',
        #     'CooOrderSerial' => '635db2e2-e818-f878-1677-650704349bbe',
        #     'Uin' => '710867296',
        #     'GoodsId' => 'com.mst.diamond_60',
        #     'GoodsInfo' => 'com.mst.diamond_60',
        #     'GoodsCount' => '1',
        #     'OriginalMoney' => '1.00',
        #     'OrderMoney' => '1.00',
        #     'Note' => '充值',
        #     'PayStatus' => '1',
        #     'CreateTime' => '2014-06-04 11:58:21',
        #     'Sign' => 'd1d60877ce5f59e7fe9f7c6949169ad7',
        # );
        $this->debug = 1;
        $this->appId = '114312';
        $this->appKey = "64f868fc07fb3c688243f176061f982a32035b99ed0a86ce";
        $this->platformName = 'i_91';
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

        if($this->debug) $this->log(var_export($_REQUEST, TRUE));
        $this->setRequest();

        $Result = array();//存放结果数组
        //因为这个DEMO是接收验证支付购买结果的操作，所以如果此值不为1时就是无效操作
        if($_REQUEST['Act'] != 1){
            $this->log('Act Error:' . var_export($data, TRUE));
            $Result["ErrorCode"] =  "3";//注意这里的错误码一定要是字符串格式
            $Result["ErrorDesc"] =  urlencode("Act无效");
            $Res = json_encode($Result);
            print_r(urldecode($Res));
            return;
        }
        // 验证AppId
        if(!$this->verifyAppId()){
            $Result["ErrorCode"] =  "2";//注意这里的错误码一定要是字符串格式
            $Result["ErrorDesc"] =  urlencode("AppId无效");
            $Res = json_encode($Result);
            print_r(urldecode($Res));
            return;
        }
        // 验证签名
        if(!$this->verifySign()){
            $Result["ErrorCode"] =  "5";//注意这里的错误码一定要是字符串格式
            $Result["ErrorDesc"] =  urlencode("Sign无效");
            $Res = json_encode($Result);
            print_r(urldecode($Res));
            return;
        }
        // Save
        $this->saveOrder();
        // OK
        $Result["ErrorCode"] =  "1";//注意这里的错误码一定要是字符串格式
        $Result["ErrorDesc"] =  urlencode("接收成功");
        $Res = json_encode($Result);
        print_r(urldecode($Res));
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
