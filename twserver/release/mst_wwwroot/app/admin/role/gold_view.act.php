<?php

/* -----------------------------------------------------+
 * 玩家金币流动明细
 * @author Rolong<rolong@vip.qq.com>
 +----------------------------------------------------- */

class Act_Gold_View extends Page
{

    private
        $log_type,
        $dbh;
    public $month = '';

    public function __construct()
    {
        parent::__construct();
        if(!$this->input['id']) {
            exit("ERROR ID!");
        }
        include(WEB_DIR . "/protocol/log_type.php");
        $this->log_type = $log_type;

        if ($this->input['month'] > 0)
            $this->month = $this->input['month'];
        else
            $this->month = date('Ym');
    }

    public function process()
    {
        $db = Db::getInstance();
        $sql = "SELECT distinct `type`, SUM(`num`) as num FROM `log_gold` WHERE FROM_UNIXTIME(`ctime`,'%Y%m') = " . $this->month . " and `role_id` = ". $this->input['id'] . " group by type order by type asc";
        $data = $db->getAll($sql);
        $categories = array();
        $golds = array();
        $goldss = array();
        $this_month = $this->month % 100;
        $this_role = $this->input['id'];
        foreach ($data as $v)
        {
            //$categories[] = date('j', $v['day_stamp']);
            $categories[] = $this->log_type[$v['type']];
            //$golds[] = abs($v['num']);
            //$goldss[] = abs($v['num']);
            if($v['num']>0){
                $golds[] = $v['num'];
                $goldss[] = 0;
            }else{
                $golds[] = 0;
                $goldss[] = abs($v['num']);
            }
        }
        $this->assign('this_month', $this_month);
        $this->assign('this_role', $this_role);
        $this->assign('categories', $categories);
        $this->assign('golds', $golds);
        $this->assign('goldss', $goldss);
        // 生成日期选择下拉列表FROM_UNIXTIME(`ctime`,'%Y%m%d')
        $date_data = $db->getAll("SELECT DISTINCT FROM_UNIXTIME(`ctime`,'%Y%m') as mon_date FROM `log_gold` WHERE 1 and `role_id` = ". $this->input['id'] ." order by `ctime` desc limit 100");
        foreach ($date_data as $v){
            $dates[$v['mon_date']] = $v['mon_date'];
        }
        $this->assign('dates', Form::select("month", $dates, $this->input['month']));
        $this->display();
    }
}
