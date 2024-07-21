<?php
/**
 * 用户反馈
 * @author php7@qq.com
 */
class Act_List extends Page {
    public $db = null;
    private $limit = 30, $page = 0;
    public $type = array(
        1 => '建议',
        2 => 'BUG'
    );


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
        $sql = 'SELECT `id`, `role_id`, `type`, `ctime`, `ip`, `aid`, `content` FROM `feedback`';
        $sql2 = 'select count(*) from feedback';
        $where = array();
        if ($this->input['kw']['start_time'] && $this->input['kw']['end_time']) {
            $where[] = "ctime >=".strtotime($this->input['kw']['start_time']);
            $where[] = "ctime <=".strtotime($this->input['kw']['end_time']);
        }
        if ($this->input['kw']['name']) {
            $where[] = "aid='{$this->input['kw']['name']}'";
        }
        if ($this->input['kw']['type']) {
            $where[] = "type='{$this->input['kw']['type']}'";
        }
        if ($this->input['kw']['id']) {
            $where[] = "role_id='{$this->input['kw']['id']}'";
        }
        if ($where) {
            $sql .= " where ".implode(' and ', $where);
            $sql2 .= " where ".implode(' and ', $where);
        }
        $totalRecord = $this->db->getOne($sql2);
        $sql .= ' order by id desc';
        $limit = " limit " . ($this->page * $this->limit) . ", {$this->limit}";
        $data = $this->db->getAll($sql.$limit);
        //var_dump($data);
        foreach($data as &$Pval)
        {
            $Pval['addtime'] = date('Y-m-d H:i:s', $Pval['ctime']);
            $Pval['client_ip'] = $Pval['ip'] . '(' . Utils::ip2addr($Pval['ip']) . ')';
            $Pval['type'] = $this->type[$Pval['type']] ? $this->type[$Pval['type']] : $Pval['type'];
            $Pval['id'] = $Pval['role_id'];
            $menu = Admin::getAdminMenu();
            //$gm = $menu[32]['sub'];
            $gm = $menu[32]['sub'];
            $Pval['url'] = $gm[30]['url'];
            //var_dump($gm[30]['url']);
            $Pval['action'] =  " <a href=\"{$Pval['url']}&from_mod=online&id={$Pval['id']}\">回复</a>";
        }
        $kw['type'] = Form::select('kw[type]', array(
            ''=>'请选择',
            '1'=>'建议',
            '2'=>'BUG'
        ), isset($this->input['kw']['type']) ? $this->input['kw']['type'] : '');
        $this->assign('kw', $kw);
        $this->assign('data', $data);
        $this->assign('page', $this->createPager($totalRecord));
        $this->display();
    }

    // private function getList($sql)
    // {
    // 	$rs = $this->dbh->selectLimit($sql, $this->page * $this->limit, $this->limit);

    // 	$list = array();
    // 	$predefine = Defines::init();
    // 	$now = time();
    // 	$menu = Admin::getAdminMenu();
    //     $gm = $menu[32]['sub'];
    // 	while ($row = $this->dbh->fetch_array($rs)) {
    //         if ($gm) {
    //             $reply = '';
    //             foreach($gm as $v) {
    //                 $reply .= " | <a href=\"{$v['url']}&from_mod=online&id={$row['id']}\">{$v['title']}</a>";
    //             }
    //             $row['action'] = $reply . ' |';
    //         }else{
    //             $row['action'] = '';
    //         }
    // 		$list[] = $row;
    // 	}
    // 	return $list;
    // }

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
