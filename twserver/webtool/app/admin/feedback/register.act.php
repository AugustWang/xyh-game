<?php

/* -----------------------------------------------------+
 * 注册数据
 * @author yeahoo2000@gmail.com
 * @author Tim <mianyangone@gmail.com>
  +----------------------------------------------------- */

class Act_register extends Page
{

    private
        $dbh,
        $limit = 30,
        $page = 0;

    public function __construct()
    {
        parent::__construct();
        if ($this->input['day'] > 0)
            $this->day = $this->input['day'];
        else
            $this->day = (int)date('Ymd');

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
        $sqlOrder = " GROUP BY `time` order by `ctime` desc";
        $sqlOrder2 = " GROUP BY `ctime` order by `ctime` desc";
        $sql = "SELECT DISTINCT FROM_UNIXTIME(`ctime`,'%Y-%m-%d') as time, COUNT(id) as reg FROM  `role` ";
        $sql2 = "SELECT DISTINCT FROM_UNIXTIME(`ctime`,'%Y-%m-%d') as time, COUNT(name) as name FROM  `role` WHERE name <> '' ";
        $totalRecord = $this->dbh->getOne(preg_replace("|^SELECT.*?FROM\s|i", "SELECT COUNT(DISTINCT FROM_UNIXTIME(`ctime`,'%Y-%m-%d')) as total FROM", $sql));
        $data = $db->getAll($sql . $sqlOrder." limit ". $this->page * $this->limit.", ". $this->limit);
        $data2 = $db->getAll($sql2 . $sqlOrder." limit ". $this->page * $this->limit.", ". $this->limit);
        foreach($data as $k => $v){
            foreach($data2 as $k2 => $v2){
                if($k2 + 1 >= count($data2) && $k + 1 != count($data)){
                    $data[$k]['name'] = 0;
                }elseif($v['time'] == $v2['time']){
                    $data[$k]['name'] = $data2[$k2]['name'];
                    break;
                }
            }
        }
        //print_r($data);
        $data['page_index'] = Utils::pager(Admin::url('', '', '', true), $totalRecord, $this->page, $this->limit);
        $this->assign('data', $data);
        $this->assign('formAction', Admin::url('', '', '', true));
        $this->display();
    }
}
