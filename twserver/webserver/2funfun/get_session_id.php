<?php
include("./common.php");

try{
    $sessionId = getClient()->login($soapUsername, $soapPassword);
    show_result(array('session_id' => $sessionId));
}catch(SoapFault $e){
    $error = $e->getMessage();
    show_error($error);
}catch(Exception $e){
    $error = $e->getMessage();
    show_error($error);
}
