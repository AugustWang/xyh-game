<?php
/**********************************************
 * 商城购买统计图
 *
 * @author rolong@vip.qq.com
 **********************************************/
class Act_Shop extends Page
{
    public $db = null;
    public $month = '';

    public function __construct()
    {
        parent::__construct();
        if ($this->input['month'] > 0)
            $this->month = $this->input['month'];
        else
            $this->month = date('Ym');
    }

    public function process()
    {
        $db = Db::getInstance();
        $sql = "SELECT `shop_id`, `num` FROM `log_shop_num` WHERE mon_date = " . $this->month . " order by day_stamp asc";
        $data = $db->getAll($sql);
        $prop = array();
        $jewel = array();
        $other = array();
        $num = array();
        $this_month = $this->month % 100;
        foreach ($data as $d => $v)
        {
            if ($d['shop_id'] <=6) {
                $prop[] += $v['num'];
            }elseif ($d['shop_id'] <=15) {
                $jewel[] += $v['num'];
            }else{
                $other[] += $v['num'];
            }
        }
        $this->assign('this_month', $this_month);
        $this->assign('prop', $prop);
        $this->assign('jewel', $jewel);
        $this->assign('other', $other);
        // 生成日期选择下拉列表
        $date_data = $db->getAll("select distinct mon_date from log_user_stat order by day_stamp desc limit 100");
        foreach ($date_data as $v) {
            $dates[$v['mon_date']] = $v['mon_date'];
        }
        $this->assign('dates', Form::select("month", $dates, $this->input['month']));
        $this->display();
    }
}
