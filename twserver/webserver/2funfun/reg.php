<?php

include("./common.php");


try{
    if(!$_GET['session_id']) show_error('请输入session_id');
    if(!$_GET['email']) show_error('请输入邮箱');
    if(!$_GET['password']) show_error('请输入密码');

    $data = array(
        'email'      => $_GET['email'], // customer email
        'password'   => $_GET['password'], //the customer password
        'store_id'   => 1,  // this cannot change
        'website_id' => 1   // this cannot change
    );
    $customer_id = getClient()->customerCustomerCreate($_GET['session_id'], $data);
    if(!is_numeric($customer_id)){
        show_error('Error customer_id: '.$customer_id);
    }
    $result = array(
        'email' => $_GET['email'],
        'password' => $_GET['password'],
    );
    show_result($result);
}catch(SoapFault $e){
    $error = $e->getMessage();
    show_error($error);
}catch(Exception $e){
    $error = $e->getMessage();
    show_error($error);
}
