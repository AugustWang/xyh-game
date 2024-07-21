<?php
/**
 * 每天各个玩家在线时长统计
 */

require dirname(__FILE__).'/../../sys/boot.php';

$db = Db::getInstance();

$endTime = strtotime(date('Y-m-d'));
$startTime = $endTime - 24 * 3600; 
$page = 0;

$sql = "select * from log_login where login_time >= {$startTime} and login_time < {$endTime} order by login_time asc";
$times = array();

while($data = $db->getAll($sql." limit ".$page.",1000"))
{
    foreach($data as $val)
    {
        $t = $val['logout_time'] - $val['login_time'];
        $t = ceil($t / 60);
        $rid = $val['role_id'];
        if($val['event'] > 0 && $t > 0)
        {
            //累计在线时间
            if(isset($times[$rid])){
                $times[$rid] += $t;
            }else{
                $times[$rid] = $t;
            }
        }
    }
    $page += 1000;
}

foreach($times as $rid => $time)
{
    $db -> query("insert into log_online_time (role_id, otime, ctime) values({$rid}, {$time}, {$startTime})");
}

exit('ok');
