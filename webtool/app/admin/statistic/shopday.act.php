<?php
/**********************************************
 * 商城购买天统计图
 *
 * @author rolong@vip.qq.com
 **********************************************/
class Act_Shopday extends Page
{

    public $db = null;
    public $day = '';

    public function __construct()
    {
        parent::__construct();
        if ($this->input['day'] > 0)
            //$this->day = $this->input['day'];
            $this->day = $this->input['day'];
        else
            //$this->day = strtotime(date('Y-m-d'));
            $this->day = date('Ymd');
    }

    public function process()
    {
        $db = Db::getInstance();
        $data = $db->getAll("select `shop_id`, `num` from `log_shop_num` where `day_stamp` = $this->day");
        $prop = array();
        $jewel = array();
        $other = array();
        $num = array();
        // foreach ($data as $val)
        // {
        //     $date = $val;
        //     if (isset($num[$data])) {
        //         $num[$data] += 1;
        //     }else{
        //         $num[$data] = 1;
        //     }
        // }
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
        // $hight =  count($categories) * 50;
        // $hight = $hight > 6000 ? 6000 : $hight;
        // $hight = $hight < 300 ? 300 : $hight;
        $this->assign('prop', $prop);
        $this->assign('jewel', $jewel);
        $this->assign('other', $other);
        // 生成日期选择下拉列表
        $date_data = $db->getAll("select distinct day_stamp from log_shop_num order by id desc limit 300");
        foreach ($date_data as $v) {
            //$dates[$v['day_stamp']] = date("Y-m-d", $v['day_stamp']);
            $dates[$v['day_stamp']] = $v['day_stamp'];
        }
        $this->assign('dates', Form::select("day", $dates, $this->input['day']));
        $this->display();
    }
}
