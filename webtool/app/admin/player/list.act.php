<?php
/**
 * 用户反馈
 * @author php7@qq.com
 */
class Act_List extends Page {
    public $db = null;
    private $limit = 30, $page = 0;



    public function __construct() {
        parent::__construct();
        $this->db = Db::getInstance();
        if (isset($this->input['page']) && is_numeric($this->input['page'])) {
            $this->page = $this->input['page'];
        }
        if (isset($this->input['limit']) && is_numeric($this->input['limit'])) {
            $this->limit = $this->input['limit'];
        }
    }

    public function process ()
    {
		$sql = 'select * from role';
		$where = array();
        if($this->input['kw']['start_time'] && $this->input['kw']['end_time']) {
            $where[] = "reg_time >=".strtotime($this->input['kw']['start_time']);
            $where[] = "reg_time <=".strtotime($this->input['kw']['end_time']);
        }
		if($this->input['kw']['name']){
			$account_id=$this->db->getOne("select account_id from role where name='".$this->input['kw']['name']."'");
			$where[] = "account_id='{$account_id}'";
		}

		if($where){
			$sql .= " where ".implode(' and ', $where);
		}
        $totalRecord = $this->db->getOne(str_replace("select *", "select count(*)", $sql));
        $sql .= ' order by id desc';
        $limit = " limit " . ($this->page * $this->limit) . ", {$this->limit}";
        $data = $this->db->getAll($sql.$limit);
		foreach($data as &$Pval)
		{
			$Pval['reg_time'] = date('Y-m-d H:i:s', $Pval['reg_time']);
            $Pval['reg_ip'] = $Pval['reg_ip'] . '(' . Utils::ip2addr($Pval['reg_ip']) . ')';
		}

        $this->assign('data', $data);
        $this->assign('page', $this->createPager($totalRecord));
        $this->display();
    }

    /**
     *
     * @param int $totalRecord
     * @return string
     */
    private function createPager($totalRecord) {
        if (! $totalRecord)
            return;

        $pager = Utils::pager(Admin::url('', '','', true), $totalRecord, $this->page, $this->limit);
        return $pager;
    }

}

