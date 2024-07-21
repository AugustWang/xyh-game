<?php
/**********************************************
 * 用户统计图
 *
 * @author rolong@vip.qq.com
 **********************************************/
class Act_Tollgate2 extends Page
{
    public $db = null;
    public $month = '';
    public function __construct()
    {
        parent::__construct();
    }
    public function process()
    {
		if (($this->input['kw']['reg_st']) && ($this->input['kw']['reg_et']))
		{
			$reg_st = strtotime($this->input['kw']['reg_st']);
			$reg_et = strtotime($this->input['kw']['reg_et']);
            $time = $reg_et - $reg_st;
            if($time < 0) throw new NotifyException('你确定你选择的时间没有反逻辑？');
            if($time > 3600 * 24 * 7) throw new NotifyException('时间相差不能超过一周');
        }else{
			$reg_et = time();
			$reg_st = $reg_et - 3600 * 24 * 7;
        }
        $where_sql = " where ctime > $reg_st and ctime < $reg_et";
        $db = Db::getInstance();
        $sql = "select tollgate_newid, count(distinct id) as num from role $where_sql group by tollgate_newid order by tollgate_newid ;";
        $data = $db->getAll($sql);
        $categories = array();
        $dataset_tollgate = array();
        foreach ($data as $v)
        {
            $categories[] = $v['tollgate_newid'];
            $dataset_tollgate[]    = $v['num'];
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
