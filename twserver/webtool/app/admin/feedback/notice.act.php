<?php
/**
 * @doc 公告列表
 * @author Rolong<rolong@vip.qq.com>
 */
class Act_Notice extends Page {
    public $db = null;
    private
        $notice_type,
        $limit = 30,
        $page = 0;


    public function __construct() {
        parent::__construct();

        $notice_type[1] = "公告";
        $notice_type[2] = "广播";
        $this->notice_type = $notice_type;

        $this->db = Db::getInstance();
        //if (isset($this->input['page']) && is_numeric($this->input['page'])) {
        //    $this->page = $this->input['page'];
        //}
        //if (isset($this->input['limit']) && is_numeric($this->input['limit'])) {
        //    $this->limit = $this->input['limit'];
        //}
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

    public function process ()
    {
        if(isset($this->input['do']) && $this->input['do'] == 'hot'){
            if (extension_loaded('ropeb')) {
                $erl = new Erlang();
                $erl -> connect();
                $rt = $erl -> get('mod_admin', 'update_notice');
                $this->assign('alert', $rt);
            }else{
                $this->assign('alert', "没有安装Erlang扩展");
            }
        }else if(isset($this->input['do']) && $this->input['do'] == 'now'){
            if (extension_loaded('ropeb')) {
                $erl = new Erlang();
                $erl -> connect();
                $rt = $erl -> get('mod_admin', 'update_broadcast');
                $this->assign('alert', $rt);
            }else{
                $this->assign('alert', "没有安装Erlang扩展");
            }
        }
        $sql = 'SELECT `id`, `type`, `time`, `msg`, `start_time`, `end_time` FROM `sys_notices`';
        $sql2 = 'select count(*) from sys_notices';
        $totalRecord = $this->db->getOne($sql2);
        $sql .= ' order by id desc';
        $limit = " limit " . ($this->page * $this->limit) . ", {$this->limit}";
        $data = $this->db->getAll($sql.$limit);
        foreach($data as &$Pval)
        {
            $Pval['start_time'] = date('Y-m-d H:i:s', $Pval['start_time']);
            $Pval['end_time'] = date('Y-m-d H:i:s', $Pval['end_time']);
            $Pval['notice_type'] = $this->notice_type[$Pval['type']];
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
