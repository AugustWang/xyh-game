<?php

/* -----------------------------------------------------+
 * 自定义活动日志数据
 * @author yeahoo2000@gmail.com
 * @author Tim <mianyangone@gmail.com>
  +----------------------------------------------------- */

class Act_log_activate extends Page
{

    public $month = '';
    public $day = '';
    private
        $log_type,
        $dbh,
        $limit = 30,
        $page = 0;

    public function __construct()
    {
        parent::__construct();
        if ($this->input['month'] > 0)
            $this->month = $this->input['month'];
        else
            $this->month = date('Ym');

        if($this->input['day'] > 0)
            $this->day = $this->input['day'];
        else
            $this->day = date('Ymd');

        // include(WEB_DIR . "/protocol/log_type.php");
        // $this->log_type = $log_type;

        $this->input = trimArr($this->input);
        $this->dbh = Db::getInstance();

        $this->clearParamCache();

        if (
            isset($this->input['limit'])
            && is_numeric($this->input['limit'])
            && $this->input['limit'] <= 1000
        )
        {
            $this->limit = $this->input['limit'];
        }

        if (
            isset($this->input['page'])
            && is_numeric($this->input['page'])
        )
        {
            $this->page = $this->input['page'];
        }

        $this->assign('limit', $this->limit);
        $this->addParamCache(array('limit'=>$this->limit));
    }

    public function process()
    {
        $data = array();
        $sqlGroup1 = " GROUP BY `type`, FROM_UNIXTIME(`time`,'%Y%m%d') ";
        $sql1 = "SELECT distinct `type`, FROM_UNIXTIME(`time`,'%Y%m%d') as time, count(*) as sum FROM `activate_key` WHERE 1 ";
        $sql2 = "SELECT distinct `type`, FROM_UNIXTIME(`time`,'%Y%m%d') as time, count(*) as count FROM `activate_key` WHERE 1 and `role_id` > 0 ";
        $data1['list'] = $this->dbh->getAll($sql1 . $sqlGroup1);
        $data1['list2'] = $this->dbh->getAll($sql2 . $sqlGroup1);
        //print_r($data1['list']);
        //print_r($data1['list2']);
        //$totalRecord = $this->dbh->getOne(preg_replace("|^SELECT.*?FROM\s|i", "SELECT COUNT(*) as total FROM", $sql1.$sqlGroup1));
        foreach($data1['list'] as $k => $v){
            foreach($data1['list2'] as $k2 => $v2){
                if($v['time'] == $v2['time'] && $v['type'] == $v2['type']){
                    $data1['list'][$k]['count'] = $v2['count'];
                    $data1['list'][$k]['prob'] = round($v2['count'] / $v['sum'] * 100) . "%" ;
                } else{
                    $data1['list'][$k]['count'] = 0;
                    $data1['list'][$k]['prob'] = 0;
                }
            }
        }
        //$data1['page_index'] = Utils::pager(Admin::url('', '', '', true), $totalRecord, $this->page, $this->limit);
        $this->assign('data', $data1);
        $this->assign('formAction', Admin::url('', '', '', true));
        $this->display();
    }

}
