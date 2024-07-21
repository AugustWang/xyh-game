<?php

include("./common.php");

try{
    if(!$_GET['session_id']) show_error('请输入session_id');
    if(!$_GET['email']) show_error('请输入邮箱');
    if(!$_GET['password']) show_error('请输入密码');

    $param = array(
        'amount' => '50',
        'email' => $_GET['email'],
        'payment_method' => 'mol_wallet',
        'outer_order_id' => '1-999-o1234-1403258483',
        'platform_type' => 'mobile',
        'notify_url' => '',
        'return_url' => $returnUrl,
        'allow_new_account' => '0',
        'gameid' => $gameId,
        'cardno' => 'SPS0214795',
    );
    $sign_str = '';
    foreach ($param as $k => $v) {
        $sign_str .= $v;
    }
    echo $sign_str .= $soapUsername;
    $hash = md5($sign_str);

    $param['sessionId'] = $_GET['session_id'];
    $param['hash'] = $hash;
    $pageContents = HttpClient::quickPost('http://www.2funfun.com/onlinepay/payment/pay/', $param);
    $data = json_decode($pageContents);
    if(!$data) show_error('未知错误');
    if($data->state != 1) show_error($data->message);
    show_result($data->response);
}catch(SoapFault $e){
    $error = $e->getMessage();
    show_error($error);
}catch(Exception $e){
    $error = $e->getMessage();
    show_error($error);
}
