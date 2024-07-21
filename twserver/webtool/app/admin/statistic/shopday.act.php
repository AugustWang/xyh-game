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
    public $shop_id;

    public function __construct()
    {
        parent::__construct();
        //
        // :let n=1 | g/shop_id\[\zs\d\+/s//\=n/ | let n+=1
        $shop_id[1] = "1个强化石7";
        $shop_id[2] = "1个强化石8";
        $shop_id[3] = "1个强化石9";
        $shop_id[4] = "5个强化石7";
        $shop_id[5] = "5个强化石8";
        $shop_id[6] = "5个强化石8";
        $shop_id[7] = "1个血之宝珠";
        $shop_id[8] = "1个攻击宝珠";
        $shop_id[9] = "1个防御宝珠";
        $shop_id[10] = "1个穿刺宝珠";
        $shop_id[11] = "1个暴击宝珠";
        $shop_id[12] = "1个闪避宝珠";
        $shop_id[13] = "1个命中宝珠";
        $shop_id[14] = "1个暴强宝珠";
        $shop_id[15] = "1个免暴宝珠";
        $shop_id[18] = "1个幸运星";
        $shop_id[19] = "5个幸运星";
        $shop_id[20] = "10个幸运星";
        $shop_id[21] = "50W金币";
        $shop_id[22] = "100W金币";
        $shop_id[23] = "500W金币";
        $shop_id[24] = "10个喇叭";
        $shop_id[25] = "30个喇叭";
        $shop_id[26] = "50个喇叭";
        $this->shop_id = $shop_id;

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
        $sql = "select `shop_id`, SUM(`num`) as num from `log_shop_num` where `day_stamp` = ". $this->day. " group by `shop_id` ";
        $data = $db->getAll($sql);

        $categories = array();
        $buys = array();
        $this_day = $this->day % 100;
        foreach ($data as $v)
        {
            $categories[] = $this->shop_id[$v['shop_id']];
            $buys[] = $v['num'];
        }
        $this->assign('this_day', $this_day);
        $this->assign('categories', $categories);
        $this->assign('buys', $buys);

        // 生成日期选择下拉列表
        $date_data = $db->getAll("select distinct day_stamp from log_shop_num order by day_stamp desc limit 100");
        foreach ($date_data as $v) {
            $dates[$v['day_stamp']] = $v['day_stamp'];
        }
        $this->assign('dates', Form::select("day", $dates, $this->input['day']));
        $this->display();
    }
}
