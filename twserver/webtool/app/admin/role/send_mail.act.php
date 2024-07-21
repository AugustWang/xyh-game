<?php

/* *******************************************************
 *
 * 发送邮件
 *
 * ***************************************************** */

class Act_Send_mail extends Page
{
    private $limit = 30, $page = 0;

    public function __construct()
    {
        parent::__construct();
        $this->db = Db::getInstance();
        if (isset($this->input['page']) && is_numeric($this->input['page'])) {
            $this->page = $this->input['page'];
        }
        if (isset($this->input['limit']) && is_numeric($this->input['limit'])) {
            $this->limit = $this->input['limit'];
        }
    }

    public function process()
    {
        if ($this->input['submit'] == '发送')
        {
            $erl = new Erlang();
            $erl->connect();
            $arg = array(
                array(
                    //$this->input['id_type'],
                    //(int)$this->input['id'],
                    //(int)$this->input['fromid'],
                    //$this->input['name'],
                    $this->input['id'],
                    $this->input['body'],
                    $this->input['items'],
                )
            );
            $rt = $erl->get('lib_admin', 'send_mail', '[~s, ~s, ~s]', $arg);
            if ($rt[0] == "ok") {
                $log = sprintf("id:%s, body:%s, items:%s",
                    //$this->input['id_type'],
                    //(int)$this->input['id'],
                    //(int)$this->input['fromid'],
                    //$this->input['name'],
                    $this->input['id'],
                    $this->input['body'],
                    $this->input['items']
                );
                Admin::log(21, $log);
                $this->assign('alert', "发送成功（{$rt[1]}：{$rt[2]}）");
            }else{
                $this->assign('alert', $rt[0]);
            }
        }
        // $data = $this->getDataList();
        $this->assign('id', $this->input['id']);
        // $this->assign('data', $data);
        $this->display();
    }

    // public function getDataList(){
    //     $data = array();
    //     $sqlOrder = " order by tollgate_id desc";
    //     $sql = "select `id`, `gold`, `diamond`, `lev`, `tollgate_id`, `aid`, `name` from role";
    //     $limit = " limit " . ($this->page * $this->limit) . ", {$this->limit}";
    //     $data['list'] = $this->db->getAll($sql.$limit);
    //     $data['page_index'] = Utils::pager(Admin::url('', '', '', true), $this->page, $this->limit);

    //     return $data['page_index'];
    // }

}
?>
