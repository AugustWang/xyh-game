<?php

function check_version($v1, $v2){
    $vv1 = explode('.', $v1);
    $vv2 = explode('.', $v2);
    if(count($vv1) != count($vv2)) return 0;
    $i = 0;
    foreach($vv1 as $x){
        if($x > $vv2[$i]) return 1;
        if($x < $vv2[$i]) return -1;
        $i++;
    }
    return 0;
}

function get_server_list($serverIdsStr){
    $serverIds = explode(',', $serverIdsStr);
    $servers = include('./array_servers.php');
    $list = array();
    foreach($serverIds as $sid){
        $s = $servers[$sid];
        $list[] = "{$s['name']}|{$sid}|{$s['ip']}|{$s['port']}|{$s['status']}|{$s['info']}";
    }
    return implode("\n", $list);
}

function access_log($content = ''){
    $requestInformation = $_SERVER['REMOTE_ADDR'].', '.$_SERVER['HTTP_USER_AGENT'].', http://'.$_SERVER['HTTP_HOST'].htmlentities($_SERVER['PHP_SELF']).'?'.$_SERVER['QUERY_STRING']."\n";
    $file = @fopen('./log.txt',"a+");
    @fwrite($file, '['.date("Y-m-d H:i:s")."] " . $requestInformation . $content);  
    @fclose($file); 
}
