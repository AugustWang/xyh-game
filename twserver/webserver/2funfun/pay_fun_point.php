<?php

include("./common.php");

try{
    if(!$_GET['session_id']) show_error('请输入session_id');
    if(!$_GET['email']) show_error('请输入邮箱');
    if(!$_GET['password']) show_error('请输入密码');
    if(!$_GET['order_id']) show_error('请输入订单');

    $myOrderData = explode('-', $_GET['order_id']);
    if(count($myOrderData) != 4) show_error('订单错误1');

    $shopId = $myOrderData[0];
    if(!is_numeric($shopId)) show_error('订单错误2');

    if(!isset($shop[$shopId])) show_error('商品无效1');

    $amount = $shop[$shopId]['fun'];
    if(!is_numeric($amount)) show_error('商品无效2');

    $params = array(
        'amount' => $amount,
        'email' => $_GET['email'],
        'payment_method' => 'fun_point',
        'outer_order_id' => $_GET['order_id'],
        'platform_type' => 'mobile',
        'notify_url' => '',
        'return_url' => $returnUrl,
        'allow_new_account' => '0',
        'gameid' => $gameId,
    );

    $data = payRequest($params);

    if($data->state != 1) show_error($data->message);
    // if($data->response != 'success') show_error('儲值失敗');

    $callbackParams = array(
        'amount' => $amount,
        'email' => $_GET['email'],
        'payment_method' => 'fun_point',
        'outer_order_id' => $data->message->outerOrderId,
        'hash' => $data->message->hash,
    );

    $callbackData = payCallback($callbackParams);

    if($callbackData == 'success'){
        show_result(array('response' => 'success'));
    }else{
        show_error($callbackData);
    }
}catch(SoapFault $e){
    $error = $e->getMessage();
    show_error($error);
}catch(Exception $e){
    $error = $e->getMessage();
    show_error($error);
}

// stdClass Object
// (
//     [state] => 1
//     [message] => stdClass Object
//         (
//             [outerOrderId] => 1-999-o1234-1403258483
//             [gameid] => mengshoutang
//             [hash] => 1b57779b90d4e4680b303739509059ee
//         )
// 
//     [response] => success
// )
