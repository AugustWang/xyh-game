<?php
/**********************************************
 * 用户统计图
 *
 * @author rolong@vip.qq.com
 **********************************************/
class Act_Gold extends Page
{
    public $db = null;
    public $month = '';
    private $log_type;

    public function __construct()
    {
        parent::__construct();
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
        $sql = "SELECT distinct `type`, SUM(`num`) as num FROM `log_gold` WHERE FROM_UNIXTIME(`ctime`,'%Y%m') = " . $this->month . " group by type order by type asc";
        $data = $db->getAll($sql);
        $categories = array();
        $golds = array();
        $goldss = array();
        $this_month = $this->month % 100;
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
        $this->assign('categories', $categories);
        $this->assign('golds', $golds);
        $this->assign('goldss', $goldss);
        // 生成日期选择下拉列表FROM_UNIXTIME(`ctime`,'%Y%m%d')
        $date_data = $db->getAll("SELECT DISTINCT FROM_UNIXTIME(`ctime`,'%Y%m') as mon_date FROM `log_gold` WHERE 1 order by `ctime` desc limit 100");
        foreach ($date_data as $v){
            $dates[$v['mon_date']] = $v['mon_date'];
        }
        $this->assign('dates', Form::select("month", $dates, $this->input['month']));
        $this->display();
    }
}
