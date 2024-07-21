<?php

/* *******************************************************
 *
 * 发送短信验证码
 *
 * ***************************************************** */

class Act_Send_Verify extends Page
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
                    $this->input['telephone'],
                )
            );
            $rt = $erl->get('lib_admin', 'send_verify', '[~u, ~s]', $arg);
            // if ($rt[0] == "ok") {
            $log = sprintf("id:%d, telephone:%s",
                $this->input['id'],
                $this->input['telephone']
            );
            Admin::log(29, $log);
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
