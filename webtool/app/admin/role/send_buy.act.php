<?php

/* *******************************************************
 *
 * 充值补单
 *
 * ***************************************************** */

class Act_Send_buy extends Page
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
                    (int)$this->input['id'],
                    $this->input['buy_type'],
                )
            );
            $rt = $erl->get('lib_admin', 'add_buy', '[~u, ~s]', $arg);
            if ($rt[0] == "ok") {
                $log = sprintf("id:%d, buy_type:%s",
                    (int)$this->input['id'],
                    $this->input['buy_type']
                );
                Admin::log(34, $log);
                $this->assign('alert', "发送成功（{$rt[1]}：{$rt[2]}）");
            }else{
                $this->assign('alert', $rt[0]);
            }
        }
        $this->assign('id', $this->input['id']);
        $this->display();
    }

}
?>
