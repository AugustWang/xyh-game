<?php 
// @author Rolong<rolong@vip.qq.com>

function get_extension($file)
{
    return substr($file, strrpos($file, '.')+1);
}

function get_os()
{
    $agent = $_SERVER['HTTP_USER_AGENT'];
    $os = 'default';
    if (strpos($agent, 'Mac')){ 
        $os = 'ios';
    }else if(strpos($agent, 'Android')){
        $os = 'android'; 
    }
    return $os;
}

