<?php

/* -----------------------------------------------------+
 * 额外活动日志数据
 * @author yeahoo2000@gmail.com
 * @author Tim <mianyangone@gmail.com>
  +----------------------------------------------------- */

class Act_log_extra extends Page
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
        $db = Db::getInstance();
        $data = array();
        $sqlOrder1 = " order by ctime desc";
        //$sqlGroup1 = " GROUP BY FROM_UNIXTIME(`ctime`,'%Y%m%d'), `type` ";
        $sql1 = "SELECT `ctime`, `type`, `body`, `start_time`, `end_time`, `count` FROM `log_extra_stat` WHERE 1 ";
        //if($this->input['month']) {
        //    $sql1 .= " AND FROM_UNIXTIME(`ctime`,'%Y%m') = ". $this->input['month'];
        //}
        if($this->input['day']) {
            $sql1 .= " AND FROM_UNIXTIME(`ctime`,'%Y%m%d') = ". $this->input['day'];
        }
        //if($this->input['type']) {
        //    $sql1 .= " AND `type` = ". $this->input['type'];
        //}
        //echo $sql1 . $sqlGroup1 . $sqlOrder1;
        $totalRecord = $this->dbh->getOne(preg_replace("|^SELECT.*?FROM\s|i", "SELECT COUNT(*) as total FROM", $sql1));
        $data1['list'] = $db->getAll($sql1 . $sqlOrder1 ." limit ". $this->page * $this->limit.", ".$this->limit);
        //foreach($data1 as $k => $v){
        //    $data1[$k]['log_type'] = $this->log_type[$v['type']];
        //}
        //print_r($data1);
        $data1['page_index'] = Utils::pager(Admin::url('', '', '', true), $totalRecord, $this->page, $this->limit);
        $this->assign('data', $data1);
        $this->assign('formAction', Admin::url('', '', '', true));
        // 生成日期选择下拉列表
        $date_data = $db->getAll("SELECT DISTINCT FROM_UNIXTIME(`ctime`,'%Y%m%d') as day_date FROM `log_extra_stat` WHERE 1 order by `ctime` desc limit 30");
        foreach ($date_data as $v){
            $dates[0] = "==全部==";
            $dates[$v['day_date']] = $v['day_date'];
        }
        $this->assign('dates', Form::select("day", $dates, $this->input['day']));
        //$this->assign('type', Form::select('type', $this->log_type, $this->input['type']));
        $this->display();
    }

}
