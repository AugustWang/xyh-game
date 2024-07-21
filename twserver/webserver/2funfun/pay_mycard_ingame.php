<?php

include("./common.php");

try{
    if(!$_GET['session_id']) show_error('请输入session_id');
    if(!$_GET['email']) show_error('请输入邮箱');
    if(!$_GET['password']) show_error('请输入密码');
    if(!$_GET['cardno']) show_error('请输入卡号');
    if(!$_GET['cardpwd']) show_error('请输入卡密码');

    if(!$_GET['order_id']) show_error('请输入订单');

    $myOrderData = explode('-', $_GET['order_id']);
    if(count($myOrderData) != 4) show_error('订单错误');

    if($myOrderData[0] != 0) show_error('商品无效');

    $params = array(
        'amount' => '1',
        'email' => $_GET['email'],
        'payment_method' => 'mycard_ingame',
        'outer_order_id' => $_GET['order_id'],
        'platform_type' => 'mobile',
        'notify_url' => '',
        'return_url' => $returnUrl,
        'allow_new_account' => '0',
        'gameid' => $gameId,
        'cardno' => $_GET['cardno'],
        'cardpwd' => $_GET['cardpwd'],
    );

    $data = payRequest($params);
    if($data->state != 1) show_error($data->message);
    $amount = $data->message->balance;
    $myOrderData[0] = '0'.($amount * 2);
    $orderId = implode('-', $myOrderData);
    $callbackParams = array(
        'amount' => $amount,
        'email' => $_GET['email'],
        'payment_method' => 'mycard_ingame',
        'outer_order_id' => $orderId,
        'cardno' => $data->message->cardno,
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
//             [balance] => 50
//             [cardno] => 1111111111111111
//             [hash] => 2a2818bace3dd1b176966a8248f5d639
//         )
// 
//     [response] => stdClass Object
//         (
//             [outerOrderId] => 1-999-o1234-1403258483
//             [gameid] => mengshoutang
//             [balance] => 50
//             [cardno] => 1111111111111111
//             [hash] => 2a2818bace3dd1b176966a8248f5d639
//         )
// 
// )
