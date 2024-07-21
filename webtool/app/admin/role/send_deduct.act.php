<?php

/* *******************************************************
 *
 * 扣除货币
 *
 * ***************************************************** */

class Act_Send_deduct extends Page
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
                    //$this->input['id_type'],
                    (int)$this->input['id'],
                    $this->input['money_type'],
                    (int)$this->input['money'],
                )
            );
            $rt = $erl->get('lib_admin', 'set_attr', '[~u, ~a, ~u]', $arg);
            //var_dump($rt);
            if ($rt[0] == "ok") {
                $log = sprintf("id:%d, money_type:%s, num:%d",
                    //$this->input['id_type'],
                    $this->input['id'],
                    $this->input['money_type'],
                    $this->input['money']
                );
                Admin::log(30, $log);
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
