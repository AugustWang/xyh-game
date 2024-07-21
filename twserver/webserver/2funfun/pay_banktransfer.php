<?php

include("./common.php");

try{
    if(!$_GET['session_id']) show_error('请输入session_id');
    if(!$_GET['email']) show_error('请输入邮箱');
    if(!$_GET['password']) show_error('请输入密码');
    if(!$_GET['order_id']) show_error('请输入订单');

    $myOrderData = explode('-', $_GET['order_id']);
    if(count($myOrderData) != 4) show_error('订单错误');

    $shopId = $myOrderData[0];
    if(!is_numeric($shopId)) show_error('订单错误2');

    if(!isset($shop[$shopId])) show_error('商品无效1');

    $amount = $shop[$shopId]['usd'];
    if(!is_numeric($amount)) show_error('商品无效2');

    $params = array(
        'amount' => $amount,
        'email' => $_GET['email'],
        'payment_method' => 'banktransfer',
        'outer_order_id' => $_GET['order_id'],
        'platform_type' => 'mobile',
        'notify_url' => '',
        'return_url' => $returnUrl."&payment_method=banktransfer",
        'allow_new_account' => '0',
        'gameid' => $gameId,
    );
    $data = payRequest($params);
    if($data->state != 1) show_error($data->message);
    show_result(array('url' => $data->response));
}catch(SoapFault $e){
    $error = $e->getMessage();
    show_error($error);
}catch(Exception $e){
    $error = $e->getMessage();
    show_error($error);
}
