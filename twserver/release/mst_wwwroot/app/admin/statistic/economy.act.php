<?php
/**********************************************
 * 用户统计图
 *
 * @author rolong@vip.qq.com
 **********************************************/
class Act_Economy extends Page
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
        $sql = "SELECT `day_stamp`, `gold_add`, `gold_sub`, `diamond_add`, `diamond_sub` FROM `log_economy` WHERE mon_date = " . $this->month . " order by day_stamp asc";
        $data = $db->getAll($sql);
        $categories = array();
        $dataset_gold_add = array();
        $dataset_gold_sub = array();
        $dataset_diamond_add = array();
        $dataset_diamond_sub = array();
        $this_month = $this->month % 100;
        foreach ($data as $v)
        {
            $categories[] = date('j', $v['day_stamp']);
            $dataset_gold_add[]    = $v['gold_add'];
            $dataset_gold_sub[]    = $v['gold_sub'];
            $dataset_diamond_add[] = $v['diamond_add'];
            $dataset_diamond_sub[] = $v['diamond_sub'];
        }
        $hight =  count($categories) * 30;
        $hight = $hight > 6000 ? 6000 : $hight;
        $hight = $hight < 300 ? 300 : $hight;
        $this->assign('hight', $hight);
        $this->assign('this_month', $this_month);
        $this->assign('categories', $categories);
        $this->assign('dataset_gold_add', $dataset_gold_add);
        $this->assign('dataset_gold_sub', $dataset_gold_sub);
        $this->assign('dataset_diamond_add', $dataset_diamond_add);
        $this->assign('dataset_diamond_sub', $dataset_diamond_sub);
        // 生成日期选择下拉列表
        $date_data = $db->getAll("select distinct mon_date from log_economy order by day_stamp desc limit 100");
        foreach ($date_data as $v){
            $dates[$v['mon_date']] = $v['mon_date'];
        }
        $this->assign('dates', Form::select("month", $dates, $this->input['month']));
        $this->display();
    }
}
