<?php
/**********************************************
 * 用户统计图
 *
 * @author rolong@vip.qq.com
 **********************************************/
class Act_Tollgate extends Page
{
    public $db = null;
    public $month = '';
    public function __construct()
    {
        parent::__construct();
    }
    public function process()
    {
        $db = Db::getInstance();
        $sql = "SELECT id, num, lost_num from tollgate_sta_new order by id asc";
        $data = $db->getAll($sql);
        $categories = array();
        $dataset_tollgate = array();
        $dataset_tollgate_lost = array();
        $dataset_tollgate_rate = array();
        foreach ($data as $v)
        {
            $categories[] = $v['id'];
            $dataset_tollgate[]    = $v['num'];
            $dataset_tollgate_lost[]    = $v['lost_num'];
            $dataset_tollgate_rate[]    = $v['num'] > 0 ? ceil($v['lost_num'] / $v['num'] * 100) : 0;
        }
        $hight =  count($categories) * 30;
        $hight = $hight > 6000 ? 6000 : $hight;
        $hight = $hight < 300 ? 300 : $hight;
        $this->assign('hight', $hight);
        $this->assign('categories', $categories);
        $this->assign('dataset_tollgate', $dataset_tollgate);
        $this->assign('dataset_tollgate_lost', $dataset_tollgate_lost);
        $this->assign('dataset_tollgate_rate', $dataset_tollgate_rate);
        $this->display();
    }
}
