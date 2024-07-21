<?php
/**********************************************
 * 实时注册量统计图
 *
 * @author rolong@vip.qq.com
 **********************************************/
class Act_Reg extends Page
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
        $data = $db->getAll("select ctime from log_reg where day_stamp = $this->day");
        $categories = array();
        $dataset_reg = array();
        $num = array();
        foreach ($data as $val)
        {
            $date = date('H:0:0', $val['ctime']);
            if (isset($num[$date]))
            {
                $num[$date] += 1;
            }else{
                $num[$date] = 1;
            }
        }
        foreach ($num as $d => $v)
        {
            $categories[] = $d;
            $dataset_reg[] = $v;
        }
        $hight =  count($categories) * 50;
        $hight = $hight > 6000 ? 6000 : $hight;
        $hight = $hight < 300 ? 300 : $hight;
        $this->assign('hight', $hight);
        $this->assign('categories', $categories);
        $this->assign('dataset_reg', $dataset_reg);
        // 生成日期选择下拉列表
        $date_data = $db->getAll("select distinct day_stamp from log_reg order by id desc limit 300");
        foreach ($date_data as $v){
            $dates[$v['day_stamp']] = date("Y-m-d", $v['day_stamp']);
        }
        $this->assign('dates', Form::select("day", $dates, $this->input['day']));
        $this->display();
    }
}
