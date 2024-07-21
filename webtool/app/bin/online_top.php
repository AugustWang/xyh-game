<?php
/**
 * 昨天最高在线
 * @author @@:249828165
 */
require dirname(__FILE__).'/../../sys/boot.php';

$db = Db::getInstance();
$endTime = strtotime(date('Y-m-d')) + 24 * 3600;

//test
$startTime = $db->getOne("select ctime from log_online_num order by id asc limit 1");
$cache = array();

while($startTime < $endTime)
{
	$st = strtotime(date('Y-m-d H:i', $startTime));
        date('Y-m-d H:i', $startTime);
	//按分钟统计
        $sql = "select sum(num) from log_online_num where ctime >={$st} and ctime <".($st+60);
	$num = (int)$db->getOne($sql);
	$date=date('Y-m-d', $startTime);
	
	if($num > $cache[$date]['num'])
	{
		echo "{$date}:{$num}\n";
		$cache[$date] = array(
			'num' =>$num,
			'ctime' => $st,
		);
	}
	$startTime += 60;
	sleep(1);
}

// $db->query("TRUNCATE TABLE `log_online_top`");
$sql = "insert into log_online_top (ctime, num) values";
$sp = '';
foreach($cache as $val)
{
	$sql .= $sp."('{$val['ctime']}','{$val['num']}')";
	$sp = ',';
}
$db->query($sql);

exit('ok');
