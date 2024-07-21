<?php
/**********************************************
 * 用户统计图
 *
 * @author rolong@vip.qq.com
 **********************************************/
class Act_Diamond extends Page
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
        $sql = "SELECT distinct `type`, SUM(`num`) as num FROM `log_diamond` WHERE FROM_UNIXTIME(`ctime`,'%Y%m') = " . $this->month . " group by type order by type asc";
        $data = $db->getAll($sql);
        $categories = array();
        $diamonds = array();
        $diamondss = array();
        $this_month = $this->month % 100;
        foreach ($data as $v)
        {
            //$categories[] = date('j', $v['day_stamp']);
            $categories[] = $this->log_type[$v['type']];
            //$diamonds[] = abs($v['num']);
            //$diamondss[] = abs($v['num']);
            if($v['num']>0){
                $diamonds[] = $v['num'];
                $diamondss[] = 0;
            }else{
                $diamonds[] = 0;
                $diamondss[] = abs($v['num']);
            }
        }
        $this->assign('this_month', $this_month);
        $this->assign('categories', $categories);
        $this->assign('diamonds', $diamonds);
        $this->assign('diamondss', $diamondss);
        // 生成日期选择下拉列表FROM_UNIXTIME(`ctime`,'%Y%m%d')
        $date_data = $db->getAll("SELECT DISTINCT FROM_UNIXTIME(`ctime`,'%Y%m') as mon_date FROM `log_diamond` WHERE 1 order by `ctime` desc limit 100");
        foreach ($date_data as $v){
            $dates[$v['mon_date']] = $v['mon_date'];
        }
        $this->assign('dates', Form::select("month", $dates, $this->input['month']));
        $this->display();
    }
}
