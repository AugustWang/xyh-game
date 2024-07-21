<?php

/* *******************************************************
 *
 * 系统广播
 *
 * ***************************************************** */

class Act_Notice_Sys extends Page
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
                    //(int)$this->input['id'],
                    //(int)$this->input['fromid'],
                    //$this->input['name'],
                    $this->input['body'],
                    //$this->input['items'],
                )
            );
            $rt = $erl->get('lib_admin', 'chat_broadcast', '[~s]', $arg);
            //var_dump($rt);
            //exit();
            if ($rt == "ok") {
                $log = sprintf("body:%s",
                    //$this->input['id_type'],
                    //(int)$this->input['id'],
                    //(int)$this->input['fromid'],
                    //$this->input['name'],
                    $this->input['body']
                    //$this->input['items']
                );
                Admin::log(23, $log);
                $this->assign('alert', "发送成功（{$rt}）");
            }else{
                $this->assign('alert', "last: {$rt} ");
            }
        }
        //$this->assign('id', $this->input['id']);
        $this->display();
    }

}
?>
