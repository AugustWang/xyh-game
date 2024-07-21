<?php

/* *******************************************************
 *
 * 设置关卡
 *
 * ***************************************************** */

class Act_Send_tollgate extends Page
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
                    // $this->input['id_type'],
                    (int)$this->input['id'],
                    // (int)$this->input['tid'],
                    (int)$this->input['num'],
                )
            );
            $rt = $erl->get('lib_admin', 'set_tollgate', '[~u, ~u]', $arg);
            // if ($rt[0] == "ok") {
            $log = sprintf("id:%d, num:%d",
                $this->input['id'],
                $this->input['num']
            );
            Admin::log(19, $log);
            $this->assign('alert', "设置成功");
            //}else{
            //    $this->assign('alert', $rt[0]);
            //}
        }
		$this->assign('id', $this->input['id']);
		$this->display();
	}
}
?>
