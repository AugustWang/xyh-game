<?php
/**
 * 在线实时统 计图表
 */
class Act_Retention extends Page
{

    public $db = null;
    public $day = '';

    public function __construct()
    {
        parent::__construct();
        if ($this->input['day'] > 0)
            $this->day = $this->input['day'];
        else
            $this->day = strtotime(date('Y-m-d'));
    }

    public function process()
    {
        $db = Db::getInstance();
        $startTime = $this->day;
        $data = $db->getAll("select reg_num, login_num, nth_day, rate from log_retention where reg_stamp = $this->day order by nth_day asc");
        $chart = array();
        $chart[] = array(
            'label' => 1,
            'value' => 100,
            'hover' => "",
        );
        foreach ($data as $v)
        {
            if($v['nth_day'] == 2){
                $prefix = '次日';
            }else{
                $prefix = $v['nth_day'] . '天';
            }
            $chart[] = array(
                'label' => $v['nth_day'],
                'value' => $v['rate'],
                'hover' => $prefix . "留存：" . $v['login_num'] . "/" . $v['reg_num'] . "=" . $v['rate'] . '%',
            );
        }
        $dates = array();
        $date_data = $db->getAll("SELECT DISTINCT reg_stamp FROM log_retention limit 100");
        foreach ($date_data as $v){
            $dates[$v['reg_stamp']] = date("Y-m-d", $v['reg_stamp']);
        }
        $this->assign('chart', $chart);
        $this->assign('dates', Form::select("day", $dates, $this->input['day']));
        $this->display();
    }
}
