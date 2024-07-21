<?php
include("./common.php");

try{
    if(!$_GET['session_id']) show_error('请输入session_id');
    if(!$_GET['email']) show_error('请输入邮箱');
    if(!$_GET['password']) show_error('请输入密码');

    $data = array(
        'filter' => array(
            array(
                'key' => 'email',
                'value' => $_GET['email']
            ),
            array(
                'key' => 'password',
                'value' => $_GET['password'] //可以为明文，也可以为HASH密码（对于网站跳转登录时）
            ),
        )
    );
    $rtn = getClient()->customerCustomerLogin($_GET['session_id'], $data);

    ## Array
    ## (
    ##     [0] => stdClass Object
    ##         (
    ##             [customer_id] => 201530
    ##             [created_at] => 2014-08-18 00:54:07
    ##             [updated_at] => 2014-08-18 00:54:07
    ##             [store_id] => 1
    ##             [website_id] => 1
    ##             [created_in] => Default Store View
    ##             [email] => php6@qq.com
    ##             [firstname] => zhong
    ##             [lastname] => ruixian
    ##             [group_id] => 0
    ##             [password_hash] => 7f55a71b5a4bdaddd622229e33286df7:x8
    ##         )
    ## 
    ## )

    $result = array(
        'email' => $rtn[0]->email,
        'password' => $rtn[0]->password_hash,
    );
    show_result($result);
}catch(SoapFault $e){
    $error = $e->getMessage();
    show_error($error);
}catch(Exception $e){
    $error = $e->getMessage();
    show_error($error);
}
