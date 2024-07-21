<?php

/* *******************************************************
 *
 * 发送货币
 *
 * ***************************************************** */

class Act_Send_money extends Page
{

	public function __construct()
	{
		parent::__construct();
	}

    public function process()
    {
        if ($this->input['submit'] == '发送')
        {
            $erl = new Erlang();
            $erl->connect();
            $arg = array(
                array(
                    $this->input['id_type'],
                    $this->input['id'],
                    $this->input['money_type'],
                    (int)$this->input['money'],
                )
            );
            $rt = $erl->get('lib_admin', 'add_attr', '[~a, ~s, ~a, ~u]', $arg);
            if ($rt[0] == "ok") {
                $log = sprintf("id_type:%s, id:%s, money_type:%s, num:%d",
                    $this->input['id_type'],
                    $this->input['id'],
                    $this->input['money_type'],
                    $this->input['money']
                );
                Admin::log(12, $log);
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
