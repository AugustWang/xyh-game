<?php

include("./HttpClient.class.php");

define('DEBUG', false);

// $soapUsername = 'wasai';
// $soapPassword = 'waX!sa1joMwONq';
// $gameId = 'wasai';

$soapUsername = 'mengshoutang';
$soapPassword = '823jisdo%#$';
$gameId = 'mengshoutang';

$funfunSoap = null;

$returnUrl = 'http://211.72.249.246/charge.php?mod=callback&act=a_fun';

## 人民币 	台币	美元	FUN点
## 1 6    30    0.99    300
## 2 30   150   4.99    1500
## 3 98   450   14.99   4900
## 4 148  660   21.99   7400
## 5 308  1440  47.99   15400
## 6 448  2090  69.99   22400
## 7 618  2790  94.99   30900
## 8 30   150   4.99    1500

$shop = array(
    1 => array('cny' => '6'  , 'twd' => '30'  , 'usd' => '0.99' , 'fun' => '300'  ),
    2 => array('cny' => '30' , 'twd' => '150' , 'usd' => '4.99' , 'fun' => '1500' ),
    3 => array('cny' => '98' , 'twd' => '450' , 'usd' => '14.99', 'fun' => '4900' ),
    4 => array('cny' => '148', 'twd' => '660' , 'usd' => '21.99', 'fun' => '7400' ),
    5 => array('cny' => '308', 'twd' => '1440', 'usd' => '47.99', 'fun' => '15400'),
    6 => array('cny' => '448', 'twd' => '2090', 'usd' => '69.99', 'fun' => '22400'),
    7 => array('cny' => '618', 'twd' => '2790', 'usd' => '94.99', 'fun' => '30900'),
    8 => array('cny' => '30' , 'twd' => '150' , 'usd' => '4.99' , 'fun' => '1500' ),
);

// $shop = array(
//     1 => array('cny' => '6'  , 'usd' => '0.99' , 'fun' => '3' ),
//     2 => array('cny' => '30' , 'usd' => '4.99' , 'fun' => '1' ),
//     3 => array('cny' => '98' , 'usd' => '14.99', 'fun' => '4' ),
//     4 => array('cny' => '148', 'usd' => '21.99', 'fun' => '7' ),
//     5 => array('cny' => '308', 'usd' => '47.99', 'fun' => '10'),
//     6 => array('cny' => '448', 'usd' => '69.99', 'fun' => '20'),
//     7 => array('cny' => '618', 'usd' => '94.99', 'fun' => '30'),
//     8 => array('cny' => '30' , 'usd' => '4.99' , 'fun' => '1' ),
// );

function getClient()
{
    global $funfunSoap;
    if(!$funfunSoap) 
    {
        $funfunSoap = new SoapClient('http://www.2funfun.com/api/v2_soap/?wsdl');
    }
    return $funfunSoap;
}

function show_result($data){
    if(DEBUG) {
        echo '<pre>';
        print_r($data);
        echo '</pre>';
    }
    echo json_encode($data);
}

function show_error($error){
    if(DEBUG) {
        echo '<pre>';
        print_r($error);
        echo '</pre>';
    }

    // include('utf8_chinese.php');
    // $chinese = new utf8_chinese; 
    // $error = $chinese->big5_gb2312($error); 

    echo json_encode(array('error' => $error));
    exit();
}

function payCallback($params){
    $httpClient = new HttpClient('211.72.249.246');
    $params['mod'] = 'callback';
    $params['act'] = 'a_fun';
    $httpClient->get('/charge.php', $params);
    return $httpClient->getContent();
}

function payRequest($params){
    global $soapUsername;
    $sign_str = '';
    foreach ($params as $k => $v) {
        $sign_str .= $v;
    }
    $sign_str .= $soapUsername;
    $hash = md5($sign_str);
    $params['sessionId'] = $_GET['session_id'];
    $params['hash'] = $hash;
    $pageContents = HttpClient::quickPost('http://www.2funfun.com/onlinepay/payment/pay/', $params);
    $data = json_decode($pageContents);
    if(!$data) show_error('支付請求失敗');
    return $data;
}
