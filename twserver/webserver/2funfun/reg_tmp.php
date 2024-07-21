<?php

include("./common.php");
include("./HttpClient.class.php");

try{
    if(!$_GET['session_id']) show_error('请输入session_id');
    $pageContents = HttpClient::quickGet('http://www.2funfun.com/customer/account/createTempCustomer/?sessionId='.$_GET['session_id']);
    $data = json_decode($pageContents);
    if(!$data) show_error('未知错误');
    if($data->response != 'success') show_error($data->message);
    $message = $data->message;
    if(!$message) show_error('未知错误2');
    if(!is_object($message)) show_error($message);
    show_result($message);
}catch(SoapFault $e){
    $error = $e->getMessage();
    show_error($error);
}catch(Exception $e){
    $error = $e->getMessage();
    show_error($error);
}
