<?php
/*-----------------------------------------------------+
 * 同步推充值回调处理
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/

# array (
#   'mod' => 'callback',
#   'act' => 'i_tb',
#   'source' => 'tongbu',
#   'trade_no' => '0-10001-i_tb7709443-1403063112241',
#   'amount' => '100',
#   'partner' => '140517',
#   'paydes' => 'com.mst.diamond_60',
#   'debug' => '0',
#   'tborder' => '1406181146092440',
#   'sign' => '9469f0d8cb56a166c92fa04634c38402',
# )

class Act_i_tb extends ChargeCallback{

    public function __construct(){
        parent::__construct();
    }

    public function process(){
        $this->debug = 1;
        $this->appId = 140517;
        $this->appKey = 'zK*Wj7wGTqfsCaPczJWMj7G9Tf4sCPmc';
        $this->platformName = 'i_tb';
        $this->myOrderIdField = 'trade_no';
        $this->platformOrderIdField = 'tborder';
        $this->moneyField = 'amount';
        $this->signField = 'sign';
        $this->appIdField = 'partner';
        $this->requestFields = array(
            'source'  ,
            'trade_no',
            'amount'  ,
            'partner' ,
            'paydes'  ,
            'debug'   ,
            'tborder' ,
            'sign'    ,
        );

        // setRequest
        $this->setRequest();
        $this->signData = array(
            'source'   => $this->request['source'  ],
            'trade_no' => $this->request['trade_no'],
            'amount'   => $this->request['amount'  ],
            'partner'  => $this->request['partner' ],
            'paydes'   => $this->request['paydes'  ],
            'debug'    => $this->request['debug'   ],
            'tborder'  => $this->request['tborder' ],
            'key'      => $this->appKey,
        );

        // Error Info
        $this->appIdErrorInfo = '{"status":"appId error"}';
        $this->signErrorInfo = '{"status":"sign error"}';
        $this->failedInfo = '{"status":"failed"}';
        // Success Info
        $this->successInfo = '{"status":"success"}';
        if(!$this->debug && $this->request['debug']){
            // NO DEBUG
            echo $this->failedInfo;
            return;
        }
        // Go ...
        $this->run();
    }
}
