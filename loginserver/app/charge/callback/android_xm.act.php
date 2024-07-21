<?php
/*-----------------------------------------------------+
 * 小米充值回调处理
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/
// 包名：air.turbotech.mengshoutang.mi
// 
// 密钥：
// f3b6073f-7875-181b-4c43-537c717b1eb8
// 
// appid :26108

// hash_hmac("sha1", $sign_str, $key,false)
//
// appId 必须 appId
// cpUserInfo 可选 开发商透传信息
// cpOrderId 必须 开发商订单ID
// orderConsumeType 可选 订单类型： 10：普通订单 11：直充直消订单
// orderId 必须 游戏平台订单ID
// orderStatus 必须 订单状态
// payFee 必须 支付金额，单位为分，即0.01 米币。
// payTime 必须 支付时间，格式 yyyy-MM-dd HH:mm:ss
// productCode 必须 商品代码
// productCount 必须 商品数量
// productName 必须 商品名称
// TRADE_SUCCESS 代表成功
// uid 必须 用户ID
//  $data = array (
//      'appId' => '26108',
//      'cpOrderId' => '179eaa97-b9ba-4723-a312-e62c8af39bf8',
//      'cpUserInfo' => '1-10001-android_xm34196204-1401952132790',
//      'orderId' => '21140195213741744293',
//      'orderStatus' => 'TRADE_SUCCESS',
//      'payFee' => '100',
//      'payTime' => '2014-06-05 15:10:16',
//      'productCode' => '01',
//      'productCount' => '10',
//      'productName' => '钻石',
//      'uid' => '34196204',
//  );
class Act_Android_xm extends ChargeCallback{

    public function __construct(){
        parent::__construct();
    }

    public function process(){
        $this->debug = 1;
        $this->appId = "26108";
        $this->appKey = "f3b6073f-7875-181b-4c43-537c717b1eb8";
        $this->platformName = 'a_xm';

        // TEST
        // $_REQUEST = array (
        //     'mod' => 'callback',
        //     'act' => 'xm',
        //     'appId' => '26108',
        //     'cpOrderId' => '179eaa97-b9ba-4723-a312-e62c8af39bf8',
        //     'cpUserInfo' => '1-10001-android_xm34196204-1401952132790',
        //     'orderId' => '21140195213741744293',
        //     'orderStatus' => 'TRADE_SUCCESS',
        //     'payFee' => '100',
        //     'payTime' => '2014-06-05 15:10:16',
        //     'productCode' => '01',
        //     'productCount' => '10',
        //     'productName' => '钻石',
        //     'uid' => '34196204',
        //     'signature' => '107627fa647cf590475eb3cf60347e4b36cbf82c',
        // );

        // 设置字段名
        $this->myOrderIdField = 'cpUserInfo';
        $this->platformOrderIdField = 'orderId';
        $this->moneyField = 'payFee';
        $this->signField = 'signature';
        $this->appIdField = 'appId';
        $this->requestFields = array(
            'appId'       , 
            'cpOrderId'   , 
            'cpUserInfo'  , 
            'orderId'     , 
            'orderStatus' , 
            'payFee'      , 
            'payTime'     , 
            'productCode' , 
            'productCount', 
            'productName' , 
            'uid'         , 
            'signature'   , 
        );

        $this->setRequest();
        $this->signData = array (
            'appId'       => $this->request['appId'       ],
            'cpOrderId'   => $this->request['cpOrderId'   ],
            'cpUserInfo'  => $this->request['cpUserInfo'  ],
            'orderId'     => $this->request['orderId'     ],
            'orderStatus' => $this->request['orderStatus' ],
            'payFee'      => $this->request['payFee'      ],
            'payTime'     => $this->request['payTime'     ],
            'productCode' => $this->request['productCode' ],
            'productCount'=> $this->request['productCount'],
            'productName' => $this->request['productName' ],
            'uid'         => $this->request['uid'         ],
        );

        // TODO: orderStatus 未验证

        // Error Info
        //
        // errcode	必须	状态码:
        // 200 成功
        // 1506 cpOrderId 错误
        // 1515 appId 错误
        // 1516 uid 错误
        // 1525 signature 错误
        // 3515 订单信息不一致，用于和 CP 的订单校验
        //
        // errMsg	可选	错误信息
        //
        $this->appIdErrorInfo = '{"errcode":"1515","errMsg":"appId错误"}';
        $this->signErrorInfo = '{"errcode":"1525","errMsg":"signature错误"}';
        $this->failedInfo = '{"errcode":"1506", "errMsg":"cpOrderId错误"}';
        // Success Info
        $this->successInfo = '{"errcode":"200", "errMsg":""}';
        // Go ...
        $this->run();
    }

    public function getMySign(){
        $sign_array = array();
        foreach ($this->signData as $k => $v) {
            $sign_array[] = $k . $this->signSep1 . $v;
        }
        $sign_string = join($this->signSep2, $sign_array);
        return hash_hmac("sha1", $sign_string, $this->appKey, false);
    }
}

