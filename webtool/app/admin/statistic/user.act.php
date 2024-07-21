<?php
/**********************************************
 * 用户统计图
 *
 * @author rolong@vip.qq.com
 **********************************************/
class Act_User extends Page
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
        $sql = "SELECT `day_stamp`, `reg_num`, `active_num`, `online_num` FROM `log_user_stat` WHERE mon_date = " . $this->month . " order by day_stamp asc";
        $data = $db->getAll($sql);
        $categories = array();
        $dataset_reg = array();
        $dataset_active = array();
        $dataset_login = array();
        $dataset_online = array();
        $this_month = $this->month % 100;
        foreach ($data as $v)
        {
            $categories[] = date('j', $v['day_stamp']);
            $dataset_reg[] = $v['reg_num'];
            $dataset_active[] = $v['active_num'];
            $dataset_login[] = $v['reg_num'] + $v['active_num'];
            $dataset_online[] = $v['online_num'];
        }
        $this->assign('this_month', $this_month);
        $this->assign('categories', $categories);
        $this->assign('dataset_reg', $dataset_reg);
        $this->assign('dataset_active', $dataset_active);
        $this->assign('dataset_login', $dataset_login);
        $this->assign('dataset_online', $dataset_online);
        // 生成日期选择下拉列表
        $date_data = $db->getAll("select distinct mon_date from log_user_stat order by day_stamp desc limit 100");
        foreach ($date_data as $v){
            $dates[$v['mon_date']] = $v['mon_date'];
        }
        $this->assign('dates', Form::select("month", $dates, $this->input['month']));
        $this->display();
    }
}
