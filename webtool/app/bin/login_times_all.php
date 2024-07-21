<?php
/**
 * 登录次数统计
 */
require dirname(__FILE__).'/../../sys/boot.php';

$db = Db::getInstance();
$endTime = strtotime(date('Y-m-d'));
$startTime = $endTime - 24 * 3600;

//test
$startTime = $db->getOne("select ctime from log_login order by ctime asc limit 1");
$startTime = strtotime(date('Y-m-d', $startTime));
$dieTime = $endTime;
for(; $startTime < $dieTime; $startTime += 24* 3600){
    $endTime = $startTime + 24* 3600;
    echo "$endTime = $startTime \n";
    if($db->getOne("select ctime from log_login_times where ctime = {$startTime}"))
    {
        print("已经存在\n");
        continue;
    }

    $page = 0;

    $sql = "select distinct(role_id) rid from log_login where ctime >= {$startTime} and ctime < {$endTime} and event=0 and role_id > 0";
    $json = array();

    while($data = $db->getAll($sql." limit ".$page.",1000"))
    {
        foreach($data as $val)
        {
            $level = (int)$db->getOne("select lev from role where id = ".$val['rid']);
            $json[$level] ++;
        }

        sleep(1);
        $page += 1000;
    }
    $j = json_encode($json);
    $db -> query("insert into log_login_times values({$startTime},'{$j}')");
}
exit('ok');
