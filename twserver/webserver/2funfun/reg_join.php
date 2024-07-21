<?php

include("./common.php");
include("./HttpClient.class.php");

try{
    if(!$_GET['session_id']) show_error('请输入session_id');
    if(!$_GET['tmp_email']) show_error('请输入TMP邮箱');
    if(!$_GET['tmp_password']) show_error('请输入TMP密码');
    if(!$_GET['email']) show_error('请输入邮箱');
    if(!$_GET['password']) show_error('请输入密码');

    // tmp_email+tmp_password+email+password+firstname+mobile+address+gender+{soap用户名}
    $hashStr = $_GET['tmp_email'].$_GET['tmp_password'].$_GET['email'].$_GET['password'].$soapUsername;
    $hash = md5($hashStr);

    $query = '&tmp_email='.$_GET['tmp_email'].'&tmp_password='.$_GET['tmp_password'].'&email='.$_GET['email'].'&password='.$_GET['password'].'&hash='.$hash;
    $pageContents = HttpClient::quickGet('http://www.2funfun.com/customer/account/apiCustomerConfirm/?sessionId='.$_GET['session_id'].$query);
    $data = json_decode($pageContents);
    if(!$data) show_error('未知错误');
    if($data->response != 'success') show_error($data->message);
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
