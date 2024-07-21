<?php
//请行测试getSessionId()以确认帐号是否有效
/*
 * 常见问题：

1.首先你需要通过soap请求一个会话(sessionId),通过login接口,参数为您的用户名和密码，在后续的所有操作中都需要的

注册：
    你可以通过soap的customerCustomerCreate接口注册新的会员，参数为 email,password,store_id,website_id

登录：
    您可以通过 customerCustomerLogin接口，验证会员是否有效，参数为filter，是一个二维数据，格式大约是这样的


 */

$soapUsername = 'wasai';//your soap username
$soapPassword = 'waX!sa1joMwONq';//your soap password 同时为您的MD5KEY。请注意保密
$gameId = 'wasai';//你的应用或者游戏编号


/*
 * 测试的帐号为 test@2funfun.com PWD:123456
 *
 */

function getSessionId($soapUsername,$soapPassword){
    //--------------------------------取得API SID
    $client = new SoapClient("http://www.2funfun.com/api/v2_soap/?wsdl");
    $sessionId = $client->login($soapUsername, $soapPassword);//应用的USERNAME和APIKEY
    return $sessionId;
}
$sessionId = getSessionId($soapUsername,$soapPassword);
//modifyPwd($sessionId,$soapUsername);
//echo $sessionId;
//==================================================================订单服务=============================================
//--------------------------------获取所有支付方式 josn response
function getPayments(){
    return json_decode(file_get_contents('http://www.2funfun.com/onlinepay/payment/methods'));
}

$return = (pay($gameId,$soapUsername,$sessionId));//json_decode
var_dump($return);//htmlspecialchars($return->response);
function pay($gameId,$soapUsername,$sessionId){
//--------------------------------支付----------------------------------------------------------
//使用fun_point支付，只需请求一次后就会立既扣点完成
//使用mycard_payment,mycard_ingame,banktransfer三种支付方式，会返回支付的URL，跳转至网银接口
//非FUN_POINT支付，系统会在5，10，15，20，25，30分钟推送支付结果到 notify_url
//您要先使用fun_point支付来确认流程，再完善其他的支付方式
    $data= array();
    $data['sessionId']           = $sessionId;
    $data['amount']           = '50';          // total amount 金额，如果为PAYPAL单位则为美金，mycard单位则为点数， 2funfun单位则为FUN点
    $data['email']            = 'zhong0406@gmail.com';//充值帐号，
    $data['payment_method']  = 'mycard_billing'; //支付方式  mycard_payment =>Mycard点数|mycard_ingame=>Mycard实体卡|banktransfer =>Paypal|fun_point => 储值FUN点支付
    $data['outer_order_id']  = 'mycard_payment_201309160050031121012_720'.date('YmdHis');//自定义订单号，用于返回交易结果时的校对
    $data['platform_type']   = 'mobile';//平台类型 mobile|web
    $data['notify_url']       = '';//通知的URL，2FUNFUN主动推送
    $data['return_url']       = 'http://www.123.com/trade_resule.php';//交易后立刻返回的URL 必须有notify_url或者return_url
    $data['allow_new_account']= '';//是否允许自动创建帐号
    $data['gameid']          = $gameId;//your game sku no ，如果为空。则为帐号充值
    $data['cardno'] ='11111111';  //卡号，当支付方式为mycard_ingame时。通过这个来传输卡号,amout 输入zero
    $data['cardpwd']='';  //卡密，当支付方式为mycard_ingame时。通过这个来传输卡密
    $data['sku'] ='SPS0214785';  //卡号，当支付方式为mycard_ingame时。通过这个来传输卡号,amout 输入zero

    $data['hash'] = md5(
        $data['amount']
            .$data['email']
            .$data['payment_method']
            .$data['outer_order_id']
            .$data['platform_type']
            .$data['notify_url']
            .$data['return_url']
            .$data['allow_new_account']
            .$data['gameid']
            .$data['cardno']
            .$data['cardpwd']
            .$soapUsername
    );
    $url =  'http://www.2funfun.com/onlinepay/payment/pay/?';
    foreach($data as $k=>$v){
        $url.='&'.$k.'='.$v;
    }
//echo $url;
return (post('http://www.2funfun.com/onlinepay/payment/pay/',$data));
// 失败：{"state":0,"message":"session_expired","response":""}

//----------------->对于mycard_payment 及 paypal，验证成功后会返回如下json，在response中返回一URL供游戏跳转至支付网关直接支付:
//{"state":1,"message":"","response":"\/nvp\/ReviewOrder.php?L_QTY0=1&L_AMT0=0.1&L_NAME0=fun%E9%BB%9E%E9%80%9A%E7%94%A8%E8%B2%A8%E5%B9%A3&paymentType=Sale¤cyCodeType=USD&PERSONNAME=zhong0406@gmail.com&SHIPTOSTREET=&SHIPTOCITY=&SHIPTOSTATE=&SHIPTOCOUNTRYCODE=&SHIPTOZIP=&CANCEL_URL=http:\/\/www.2funfun.com\/onlinepay\/payment\/pay\/&ORDER_ID=100000054"}

//----------------->对于mycard_ingame及 fun点，验证成功后会返回如下json，在response中返回交易的结果包括，订单号，产品ID，及交易金额（重要）:
//应用需要判断此订单号是否已经处理过。防止重复加点
// 成功后会返回支付的URL，可以直接支付:

//mycard_ingame返回示例：{"state":1,"message":null,"response":{"outerOrderId":"20130820143418","gameid":"qier","balance":50,"cardno":"1111111111111111","hash":"7cc7427ccc707d5d7ec0d8bed2fc0e4c"}}
//hash加密的顺序为
    /*
    $hash =  md5($outerOrderId.$gamerId.$balance.$cardno.$data['soap_username']
    */

//fun点返回示例：{"state":1,"message":null,"response":{"outerOrderId":"20130820143418","gameid":"qier","hash":"1cc7427cAg707d5d7ec0d8bed2fc0e4c"}}
//hash加密的顺序为
    /*
    array('outerOrderId'=>$outerOrderId,'gameid'=>$gamerId,'hash'=>md5($outerOrderId.$gamerId.$data['soap_username']));
    */


//paypal 返回

//    '".$returnUrl."?state=complete&amount=".$order['amount']."&email=".$order['email']."&outer_order_id=".$outerId."&gameid=".$gameid."&hash=".$hash."'";;
//
//    $hash    = md5( state.amount.email.outer_order_id.gameid.soap_username);

}


function getTradeResult($gameId,$soapUsername,$outerOrderId,$sessionId){
    //--------------------------------请求查询订单支付状态----------------------------------------------------------
    // -> 主动发起查询交易请求。参数为outer_order_id
    $data = array(
        'sessionId'=>$sessionId,
        'outer_order_id'=>$outerOrderId,//厂商自己的订单号
        'gameid'         => $gameId,//your game sku no ，查询的游戏编号
        'hash' =>md5($outerOrderId+$gameId+$soapUsername)
    );
    var_dump(post('http://www.2funfun.com/onlinepay/payment/traderesult/',$data));
    //game_id
}
//getTradeResultgetTradeResult($gameId,$soapUsername,$outerOrderId,$sessionId);






//==================================================================用户服务=============================================



//--------------------------------登录--------------------------------
function customerLogin($sessionId){
    $client = new SoapClient("http://www.2funfun.com/api/v2_soap/?wsdl");
    $data = array(
        'filter' => array(
            array(
                'key' => 'email',
                'value' => 'gmm4210@163.com'
            ),
            array(
                'key' => 'password',
                'value' => '123456' //可以为明文，也可以为HASH密码（对于网站跳转登录时）
            ),
        )
    );
    try {
        var_dump($client->customerCustomerLogin($sessionId,$data)) ;
    } catch (Exception $ex) {
        var_dump($ex) ;
    }
}


function register($sessionId){
    //--------------------------------注册--------------------------------
    $client = new SoapClient("http://www.2funfun.com/api/v2_soap/?wsdl");
    $data = array(
        'email'      =>  'tesxxxxt22@example.com', // customer email
        'password'   => ('111111'), //the customer password
        'store_id'   => 1,  // this cannot change
        'website_id' => 1   // this cannot change
    );
    try {
        var_dump($client->customerCustomerCreate($sessionId,$data)) ;
    } catch (Exception $ex) {
        return $ex;
    }
}


function createTmpCustomer($sessionId){
    //--------------------------------注册临时帐号--------------------------------
    $data = array(
        'sessionId'   => $sessionId,
    );
    var_dump(post('http://www.2funfun.com/customer/account/createTempCustomer/',$data));
}
//createTmpCustomer($sessionId);
//createTmpCustomer($sessionId);
function forgetPwd($soapUsername,$sessionId){
    //--------------------------------忘记密码--------------------------------
    //密码需要大于6位
    $data = array(
        'sessionId'=>$sessionId,
        'email'=>'1231231@13.com',//用户邮件
    );
    $data['hash']=md5($data['email']+$soapUsername);
    var_dump(post('http://www.2funfun.com/customer/account/apiPasswordForget/',$data));//调用
}


function apiCustomerConfirm($sessionId,$soapUsername){
//--------------------------------临时用户绑定--------------------------------
    $data = array(
        'sessionId'=>$sessionId,
        'tmp_email'=>'u54747438923675@u.2funfun.com',
        'tmp_password'=>'hyv5rCDQBqQw',
        'email'=>'1231x231@13.com',//用户邮件
        'password'=>'1231231s@13.com',//用户新密码
        'firstname'         => '1232131231',//姓名
        'mobile'         => '231232131',//手机
        'address'         => '231232131',//地址
        'gender'         => '1',//性别
    );
    $data['hash']=md5($data['tmp_email']+$data['tmp_password']+$data['email']+$data['password']+$data['firstname']+$data['mobile']+$data['address']+$data['gender']+$soapUsername);
    var_dump(post('http://www.2funfun.com/customer/account/apiCustomerConfirm/',$data));
}
//apiCustomerConfirm($sessionId,$soapUsername);
function modifyPwd($sessionId,$soapUsername){
    //--------------------------------修改密码--------------------------------
    //密码需要大于6位
        $data = array(
            'sessionId'=>$sessionId,
            'email'=>'zhong0406@gmail.com',//用户邮件
            'password'         => 'zhongjh',//当前密码
            'new_password'         => 'zhongjh',//新密码
        );
        $data['hash']=md5($data['email']+$data['password']+$data['new_password']+$soapUsername);
        var_dump(post('http://www.2funfun.com/customer/account/apiPasswordChange/',$data));
}


function customerUpdate($sessionId,$soapUsername){
//--------------------------------用户资料更新--------------------------------
    $data = array(
        'sessionId'=>$sessionId,
        'email'=>'1231231@13.com',//用户邮件
        'firstname'         => '1232131231',//姓名
        'mobile'         => '231232131',//手机
        'address'         => '231232131',//地址
        'gender'         => '1',//性别
    );
    $data['hash']=md5($data['firstname']+$data['mobile']+$data['address']+$data['gender']+$soapUsername);
    var_dump(post('http://www.2funfun.com/customer/account/apiCustomerUpdate/',$data));
}

//==================================================================公共方法=============================================
function post($url, $post = null)
{
    $context = array();
    if (is_array($post))
    {
        ksort($post);
        $context['http'] = array
        (
            'method' => 'POST',
            'header'  => 'Content-type: application/x-www-form-urlencoded',
            'content' => http_build_query($post, '', '&'),
        );
    }
    return file_get_contents($url, false, stream_context_create($context));
}

//---- 弃用的方法

//
//try {
//var_dump($client->customerCustomerLogin($sessionId,$data)) ;
//} catch (Exception $ex) {
//echo $ex->faultcode;
//echo $ex->faultstring;
//}
