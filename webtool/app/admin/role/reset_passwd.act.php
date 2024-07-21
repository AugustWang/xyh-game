<?php

/* *******************************************************
 *
 * 重置密码
 *
 * ***************************************************** */

class Act_Reset_passwd extends Page
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
                    $this->input['password'],
                )
            );
            $rt = $erl->get('lib_admin', 'reset_password', '[~u, ~s]', $arg);
            // if ($rt[0] == "ok") {
            $log = sprintf("id:%d, num:%s",
                $this->input['id'],
                $this->input['password']
            );
            Admin::log(26, $log);
            $this->assign('alert', "发送成功");
            //}else{
            //    $this->assign('alert', $rt[0]);
            //}
        }
		$this->assign('id', $this->input['id']);
		$this->display();
	}

}
?>
