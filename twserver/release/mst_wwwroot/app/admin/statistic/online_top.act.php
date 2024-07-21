<?php
/**
 * 在线峰值统计图
 */
class Act_Online_Top extends Page
{
    public $db = null;
    public $month = '';

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
        $endTime = $startTime + 24 * 3600;
        $data = $db->getAll("select distinct time_stamp, num from log_online_num where day_stamp = $this->day order by id asc");
        $categories = array();
        $dataset_online = array();
        foreach ($data as $v)
        {
            $time_stamp = (int)($v['time_stamp'] / 1800) * 1800;
            $k = date('H:i', $time_stamp);
            if (isset($dataset_online[$k]) && $dataset_online[$k] > $v['num'])
            {
                continue;
            }
            $categories[$k] = $k;
            $dataset_online[$k] = $v['num'];
        }
        $hight =  count($categories) * 30;
        $hight = $hight > 6000 ? 6000 : $hight;
        $hight = $hight < 300 ? 300 : $hight;
        $this->assign('hight', $hight);
        $this->assign('categories', $categories);
        $this->assign('dataset_online', $dataset_online);
        // 生成日期选择下拉列表
        $date_data = $db->getAll("select distinct day_stamp from log_online_num order by day_stamp desc limit 100");
        foreach ($date_data as $v){
            $dates[$v['day_stamp']] = date('Y-m-d', $v['day_stamp']);
        }
        $this->assign('dates', Form::select("day", $dates, $this->input['day']));
        $this->display();
    }
}
