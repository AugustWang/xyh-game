<?php
/*-----------------------------------------------------+
 * 2funfun充值回调处理
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/

// [2014-08-21 15:43:00] 183.16.194.71, Incutio HttpClient v0.9, http://42.62.14.78/charge.php?amount=1&email=415116909%40qq.com&payment_method=fun_point&outer_order_id=1-999-o1234-1403258483&hash=1b57779b90d4e4680b303739509059ee&mod=callback&act=a_2funfun
// array (
//   'amount' => '1',
//   'email' => '415116909@qq.com',
//   'payment_method' => 'fun_point',
//   'outer_order_id' => '1-999-o1234-1403258483',
//   'hash' => '1b57779b90d4e4680b303739509059ee',
//   'mod' => 'callback',
//   'act' => 'a_2funfun',
// )

// [2014-08-21 16:39:37] 183.16.194.71, Incutio HttpClient v0.9, http://42.62.14.78/charge.php?amount=50&email=415116909%40qq.com&payment_method=mycard_ingame&outer_order_id=1-999-o1234-2403258483&cardno=1111111111111111&hash=bfc593389def4abeae53d47a7d4620ea&mod=callback&act=a_2funfun
// array (
//   'amount' => '50',
//   'email' => '415116909@qq.com',
//   'payment_method' => 'mycard_ingame',
//   'outer_order_id' => '1-999-o1234-2403258480',
//   'cardno' => '1111111111111111',
//   'hash' => 'bfc593389def4abeae53d47a7d4620ea',
//   'mod' => 'callback',
//   'act' => 'a_2funfun',
// )

class Act_a_fun extends ChargeCallback{

    public $payment_method;
    public $google_json_data;
    public $google_sign;
    public $google_key;

    public function __construct(){
        parent::__construct();
    }

    public function process(){

        $this->debug = 1;
        $this->platformName = $_REQUEST['act'];
        // 设置字段名
        $this->myOrderIdField = 'outer_order_id';
        $this->platformOrderIdField = 'outer_order_id';
        $this->moneyField = 'amount';
        $this->signField = 'hash';
        $this->payment_method = $_REQUEST['payment_method'];
        $this->payment_method = $_REQUEST['payment_method'];
        $this->requestFields = array(
            'email',
            'payment_method',
            'outer_order_id',
            'hash',
            'cardno',
            'amount',
            'state',
        );

        $this->setRequest();
        $this->signErrorInfo = 'Sign Error';
        $this->failedInfo = 'error';
        // Success Info
        $this->successInfo = 'success';
        // Go ...
        $this->run();
    }

    public function setRequest(){
        $params = array();
        if($this->payment_method == 'google_play'){
            $this->moneyUnit = 100;
            // stdClass::__set_state(array(
            //    'orderId' => '12999763169054705758.1361218620573676',
            //    'packageName' => 'com.turbotech.mengshoutang.fun',
            //    'productId' => 'com.mst.diamond_60',
            //    'purchaseTime' => 1409039329384,
            //    'purchaseState' => 0,
            //    'developerPayload' => '1-10002-o14763-1403259481',
            //    'purchaseToken' => 'mfpnmljdbhdcplbjnffefaed.AO-J1OzxJU_NcgsK7CNH7tTcL7rVMuhUh8Z3SHwQkTxvBAwkBZDlNLtabUW_1wwx48eIkNUbGqYNvlYtfkbtrQk8XnNIj8BVrYs1qVqAIxrg6lXK9Z-vcvrw6ZyyXC0zzSunNaE7kk1UoChBS1BL_LUG-upjkftTcg',
            // ))
            $json_data = stripslashes(urldecode($_REQUEST['data']));
            $this->google_json_data = $json_data;
            $data = json_decode($json_data);
            $this->google_sign = $_REQUEST['sign'];
            // $this->log("json_data:\n" . var_export($json_data, TRUE));
            // $this->log("data:\n" . var_export($data, TRUE));
            $params['outer_order_id'] = $data->developerPayload;
            if($data->packageName == 'com.turbotech.mengshoutang.fun'){
                $this->google_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAomchDNqoGHCj+uKX1wpo4OFhyDQYMVWzj1+NlJvf3rv8Fx8gXKAWm+5FmX7uF1EPOBoXzi94WwNaZuvHQUFwJMkU+Q9/h6k+wLwnygJFEhc5+9NuAPjHRd8rSTkvBZqSfzJKuRPt7U2Lt4CQPbiDK9ltcquAC7x8ovwC30G0xI/ItonQ7+cQmIbDsDgHo2kkZLhyuXX00JRHlBgMCBst0F6LhhRR43SVdy/yQAAO5BXrQGuDJghz3iRmTDBl/vsClKnqjmAUyN7VgaKy1/dDHISSpMGQNavZJT/EGWelndDrbKTX8DqB2EGrgDyOl4yU0rTYNo5EkGa2Z87uMDvY6QIDAQAB";
            }else if($data->packageName == 'com.turbotech.mengshoutang.fun2'){
                $this->google_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAz69HtW2SN84buGVj2VM3xDw/BvCejkXdmZ/F3oJNeEvm7C+PcE8kUvAYzcK0wV/6NxkiXZrCX0L0XYCSXgVppdA/KCPHFLkfjPXbtkyCLPqmh2ccusYwc6Rtj4ndOcz6u2B0fcbwCVI7i9Z445AGMKx7dPcA3ETpPo5TozcAKOV2Yj/gD0lB+H5HmF8ZkyJBvpM6xw6d+gtd2OkZsYm3zBK0n3gqKeKdHe5nIjnDULE3LtPD6yKcRFxkK2x4xlIgymPRNXy0jur8YqBKScwUDqbgKY5T66Vd0kqjYWG0z6Y6qdpoXYc5Pl3pSg1svQlIMKwst+6SBp/bStEjkjQp1wIDAQAB";
            }else if($data->packageName == 'com.turbotech.mengshoutang.fun3'){
                $this->google_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApNq3qvWVVEAnmAuVQe1mMOiWynwM/qXgMtuvXwLrwFS+89/Acv4AqPzmdVjAG2sdAiOYycBXE8Izl9/11SMIMDc5xv0G10sB4we7YJk0mNeNi403iqMjtblL656hzkjA0p6v5IPeZ4sBxfwwBh5uNqL9N59YZxRFNEyMVAcmZE/KE3Cw4Pct7XwooaAvFmt/wwOhCLoNFAgDYxThNWpaJuIRFTg4E/F2A+x2ySFcS8N6kR/ef66ZC/lFfGs1OAg3k6pPHe8RBbMfUZQmrBEndxLzQCLacjLm+Bsbcnj+7JRo6MWXe4DfvCvrwomJHd0qGHIsprcT1XlvN8pkx3avMwIDAQAB";
            }else if($data->packageName == 'com.turbotech.mengshoutang.fun4'){
                $this->google_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAz3/Ya/inH/Kjm6yFHIPdzO+aOoA6USglM4gkRfXKFMqnoz1ckxEIM98cvff7R8o2YuWD87WbpHSkni/O1JMSkLvXGXPknT5LUusW7Jl+7PU09ufIV74RLHKEeeHNO25WxO8KJJUGVlAslD+Kua828iUiZPvvHsvttpO+ouq1AiGtQoNgithlB9xbXX3Pk4GPYNFWQmboT21hdXNo7ib5tR78xi58mgSTuvgFGABKVbsTo/KP9sHEM1yPQNMoFWJTfJNDtVe/NqzjSYbNUD93d6jxrNWIIzZVV3rhgOyXVOTeD1FTMRRWq9PZUSlm4cp2G8+MgrskjpovaIaFB5JDPwIDAQAB";
            }

            $shopId = $this->getShopId($params['outer_order_id']);

            $shop = array(
                1 => '6'  ,
                2 => '30' ,
                3 => '98' ,
                4 => '148',
                5 => '308',
                6 => '448',
                7 => '618',
                8 => '30' ,
            );

            $params['amount'] = $shop[$shopId];
            $params['payment_method'] = $this->payment_method;
            $params['state'] = $data->packageName;
        }else{
            foreach($this->requestFields as $v){
                if(isset($_REQUEST[$v])) $params[$v] = $_REQUEST[$v];
            }
        }
        $this->request = $params;
    }

    public function verifySign(){
        if($this->payment_method == 'google_play'){
            $public_key = "-----BEGIN PUBLIC KEY-----\n" . chunk_split($this->google_key, 64, "\n") .  "-----END PUBLIC KEY-----";
            $public_key_handle = openssl_get_publickey($public_key);
            $result = openssl_verify($this->google_json_data, base64_decode($this->google_sign), $public_key_handle, OPENSSL_ALGO_SHA1);
            if ($result != 1) {
                if($this->debug){
                    $this->log("Error Google Play Sign\n");
                }
                return false;
            }
        }else{
            $recvSign = $this->request[$this->signField];
            $mySign = $this->getMySign();
            if($recvSign != $mySign){
                if($this->debug){
                    $this->log("Error Sign: {$mySign} != {$recvSign}\n");
                }
                return false;
            }
        }
        return true;
    }

    public function getSignString(){
        // $soapUsername = 'wasai';
        // $gameId = 'wasai';
        $soapUsername = 'mengshoutang';
        $gameId = 'mengshoutang';
        switch($this->payment_method){
        case 'fun_point':
            $this->moneyUnit = 2.053;
            $signString = $this->request['outer_order_id'].$gameId.$soapUsername;
            break;
        case 'mycard_ingame':
            $this->moneyUnit = 20.53;
            $myOrderData = explode('-', $this->request['outer_order_id']);
            $myOrderData[0] = '0';
            $orderId = implode('-', $myOrderData);
            if($this->request['cardno'] == '1111111111111111'){
                echo 'Disable Test';
                exit();
            }
            $signString = $orderId.$gameId.$this->request['amount'].$this->request['cardno'].$soapUsername;
            break;
        case 'mycard_payment':
            $this->moneyUnit = 20.53;
            $this->successInfo = $this->getSuccessInfo();
            $signString = 'complete'.$this->request['amount'].$this->request['email'].$this->request['outer_order_id'].$gameId.$soapUsername;
            break;
        case 'banktransfer':
            // [2014-09-01 13:56:08] 106.187.94.131, Mozilla/5.0 (Linux; U; Android 4.1.2; zh-cn; GT-N7100 Build/JZO54K) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30, 
            // http://211.72.249.246/charge.php?mod=callback&act=a_fun&state=complete&amount=30.0000&email=hiiko@163.com&outer_order_id=1-200-o10-1409551083&gameid=mengshoutang&hash=30d7bbafee2e693af181e6df977462b7
            // array (
            //   'PHPSESSID' => '8gr7dnmelf8d19q8muq3gegtn3',
            //   'mod' => 'callback',
            //   'act' => 'a_fun',
            //   'state' => 'complete',
            //   'amount' => '30.0000',
            //   'email' => 'hiiko@163.com',
            //   'outer_order_id' => '1-200-o10-1409551083',
            //   'gameid' => 'mengshoutang',
            //   'hash' => '30d7bbafee2e693af181e6df977462b7',
            // )
            // returnUrl?state=complete&amount=".$order['amount']."&email=".$order['email']."&outer_order_id=".$outerId."&gameid=".$gameid."&hash=".$hash
            // Hash 顺序：
            // md5(state+amount+email+outer_order_id+gameid+ soap_username)
            $this->moneyUnit = 615.2;
            $this->successInfo = $this->getSuccessInfo();
            $signString = 'complete'.$this->request['amount'].$this->request['email'].$this->request['outer_order_id'].$gameId.$soapUsername;
            break;
        default:
            $this->moneyUnit = 1;
            $signString = '';
        }
        return $signString;
    }

    public function getShopId($order){
        $myOrderData = explode('-', $order);
        return $myOrderData[0];
    }

    public function getSuccessInfo(){
        return '<html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /></head><body>支付成功，請按【回退鍵】返回遊戲。</body></html>';
    }
}
