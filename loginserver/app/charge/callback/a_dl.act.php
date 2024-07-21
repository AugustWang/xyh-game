<?php
/*-----------------------------------------------------+
 * 当乐充值回调处理
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/
// 应用ID(APP_ID) ：1436
// 
// 厂商ID(MERCHANT_ID) :750
// 
// 应用密钥(APP_KEY) ：cRKnb8Rw
// 
// 支付密钥(PAYMENT_KEY) ：Hkb4c675qUuV
class Act_a_dl extends ChargeCallback{

    public function __construct(){
        parent::__construct();
    }

    public function process(){
        $this->debug = 1;
        $this->appId = "1436";
        $this->appKey = "cRKnb8Rw";
        $this->platformName = $_REQUEST['act'];
        // 设置字段名
        $this->myOrderIdField = 'ext';
        $this->platformOrderIdField = 'order';
        $this->moneyField = 'money';
        $this->moneyUnit = 100;
        $this->signField = 'signature';
        $this->appIdField = '';
        $this->requestFields = array(
            'result',
            'money',
            'order',
            'mid',
            'time',
            'signature',
            'ext',
        );
        if($this->debug) $this->log(var_export($_REQUEST, TRUE));
        $this->setRequest();
        // 验证订单状态
        if($this->request['result'] == 0){
            // 返回成功，表示已收到请求
            echo 'success';
            $this->log('error status:'.var_export($_REQUEST, TRUE), true);
            return;

        }
        // order=_&money=_&mid=_&time=_&result=_&ext=_&key=_
        $this->signData = array(
            'order'      => $this->request['order'    ],
            'money'      => $this->request['money'    ],
            'mid'        => $this->request['mid'      ],
            'time'       => $this->request['time'     ],
            'result'     => $this->request['result'   ],
            'ext'        => $this->request['ext'      ],
            'key'        => 'Hkb4c675qUuV',
        );

        // Error Info
        $this->signErrorInfo = 'Sign Error';
        $this->failedInfo = 'failed';
        // Success Info
        $this->successInfo = 'success';
        // Go ...
        $this->run();
    }
}
